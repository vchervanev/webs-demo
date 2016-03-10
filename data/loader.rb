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

input.sort! { |x,y| y[CONST::IMPORTANCE] <=> x[CONST::IMPORTANCE]}

class String
  def fix(length=15)
    self.ljust(length)[0..length-1]
  end
end

def to_row(array)
  array.map(&:fix).join("|")
end

puts to_row(HEADERS)
input.each { |x| puts to_row(x)}

