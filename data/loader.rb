require 'redis'
require 'csv'

$R = Redis.new( url: ENV['REDIS_URL'])

input = CSV.parse(File.read('sample_data.csv'))
HEADERS = input.shift.map { |item| item.match(/\s*(.+)\s*/)[1]}

module CONST
  HEADERS.each_with_index { |name, value| self.const_set(name.upcase, value) }
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

p CONST::INTERESTS

input.each { |row| row[CONST::IMPORTANCE] = row[CONST::IMPORTANCE].to_i; row[CONST::INTERESTS] = row[CONST::INTERESTS].tr('{}"', '').split(',') }
input.sort! { |x,y| y[CONST::IMPORTANCE] <=> x[CONST::IMPORTANCE]}

general_queue = input.map { |row| [row[CONST::ID], row[CONST::IMPORTANCE]]}

total_interests = input.inject(0){ |a,b| a + b[CONST::INTERESTS].length }

queues = Hash.new{|h,k| h[k] = [] }
input.each do |row|
  row[CONST::INTERESTS].each do |interest|
    queues[interest.to_sym].push [row[CONST::ID], row[CONST::IMPORTANCE]]
  end
end

total_converted_interests = queues.map {|k,v| v.length}.inject(0){|a,b|a+b}
raise 'test failed' unless total_interests == total_converted_interests

class QueueAdapter
  attr_reader :eof, :iterator
  def initialize(array)
    @iterator = array.each
    @eof = false
  end

  def next
    eof ? nil : safe_next
  end

  def safe_next
    iterator.next
  rescue StopIteration
    @eof = true
    nil
  end
end

# inline tests
q = QueueAdapter.new([4])
raise 'test failed' if q.eof
raise 'test failed' unless q.next == 4
raise 'test failed' if q.eof
raise 'test failed' unless q.next.nil?
raise 'test failed' unless q.eof


class Mixer

  def mix(queue1, queue2)
    @listed = {}
    q1 = QueueAdapter.new(queue1)
    q2 = QueueAdapter.new(queue2)
    [].tap do |result|
      until q1.eof && q2.eof
        if (v = extract(q1))
          result.push(v)
        end
        if (v = extract(q2))
          result.push(v)
        end
      end
    end
  end

  private

  def extract(q)
    while true
      value = q.next
      if value && @listed.include?(value[0])
        next
      else
        @listed[value[0]] = true if value
        return value
      end
    end
  end
end

m = Mixer.new
result = m.mix([[1],[2],[3]], [[4],[5],[6]])
raise 'test failed' unless result == [[1], [4], [2], [5], [3], [6]]

raise 'Need more tests'

