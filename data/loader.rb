require 'redis'
require 'csv'
require_relative 'tools/helpers'

input = CSV.parse(File.read('sample_data.csv'))
HEADERS = input.shift.map &:strip

module CONST
  HEADERS.each_with_index { |name, value| self.const_set(name.upcase, value) }
  # ID
  # FIRST_NAME
  # LAST_NAME
  # COUNTRY
  # TITLE
  # COMPANY
  # IMPORTANCE
  # BIO
  # INTERESTS
  # THUMBNAIL_URL
  # IMAGE_URL
end

input.each do |row|
  row[CONST::IMPORTANCE] = row[CONST::IMPORTANCE].to_i
  row[CONST::INTERESTS] = row[CONST::INTERESTS].tr('{}"', '').split(',').map(&:to_sym)
end

input.sort! { |x,y| y[CONST::IMPORTANCE] <=> x[CONST::IMPORTANCE]}

general_queue = input

queues = Hash.new{|h,k| h[k] = [] }
input.each do |row|
  row[CONST::INTERESTS].each do |interest|
    queues[interest.to_sym].push row
  end
end

targeted_queue = {}

queues.each do |name, array|
  targeted_queue[name] = ConditionalMixer.mix(general_queue, array) { |row| !row[CONST::INTERESTS].include?(name) }
end

# test
require_relative 'tools/targeted_view_test'
TargetedViewTest.perform(targeted_queue)

# update redis data
$R = Redis.new( url: ENV['REDIS_URL'])
$R.multi

$R.del 'general_queue'
$R.keys('targeted_queues/*').each { |queue| $R.del(queue) }
$R.del 'general_queue'
$R.rpush 'general_queue', general_queue.map {|item|item[CONST::ID]}

targeted_queue.each do |interest, array|
  $R.rpush "targeted_queues/#{interest.to_s}", array.map {|item|item[CONST::ID]}
end

# prepare redis-like object [id, value, id, value, ...]
object = HEADERS.zip([]).flatten

input.each do |item|
  item.each_with_index { |value, index| object[index*2+1] = value }
  # make UI-friendly interests
  object[CONST::INTERESTS*2+1] = object[CONST::INTERESTS*2+1].join(', ')
  $R.hmset("speaker/#{item[CONST::ID]}", object)
end

$R.exec
