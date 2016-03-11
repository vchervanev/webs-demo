class QueueAdapter
  attr_reader :eof, :iterator
  def initialize(array)
    @iterator = array.each
    @eof = false
  end

  def next
    eof ? nil : safe_next
  end

  private

  def safe_next
    iterator.next
  rescue StopIteration
    @eof = true
    nil
  end
end

class FilteredQueueAdapter
  attr_reader :queue, :filter

  def initialize(queue, &filter)
    @queue = queue
    @filter = filter
  end

  def next
    value = nil
    until queue.eof
      value = queue.next
      break if value && filter.call(value)
    end
    value
  end

  def eof
    @queue.eof
  end
end

# inline tests
q = QueueAdapter.new([4])
raise 'test failed' if q.eof
raise 'test failed' unless q.next == 4
raise 'test failed' if q.eof
raise 'test failed' unless q.next.nil?
raise 'test failed' unless q.eof

fq = FilteredQueueAdapter.new(QueueAdapter.new([1,2,3])) { |v| v % 2 == 0}
raise 'test failed' if fq.eof
raise 'test failed' unless fq.next == 2
raise 'test failed' if fq.eof
raise 'test failed' unless fq.next == nil
raise 'test failed' unless fq.eof

class ConditionalMixer

  def self.mix(array1, array2, &filter)
    @listed = {}
    q1 = FilteredQueueAdapter.new(QueueAdapter.new(array1), &filter)
    q2 = QueueAdapter.new(array2)
    [].tap do |result|
      until q1.eof && q2.eof
        push_if(result, q1.next)
        push_if(result, q2.next)
      end
    end
  end

  private

  def self.push_if(array, item)
    array.push(item) if item
  end
end

result = ConditionalMixer.mix([[1],[2],[3]], [[4],[5],[6]]) { true }
raise 'test failed' unless result == [[1], [4], [2], [5], [3], [6]]

result = ConditionalMixer.mix([[1, true],[2, true],[3, true]], [[4],[5],[6]]) { |v| v[1] }
raise 'test failed' unless result == [[1, true], [4], [2, true], [5], [3, true], [6]]

result = ConditionalMixer.mix([[1, false],[2, true],[3, true]], [[1],[4],[5]]) { |v| v[1] }
raise 'test failed' unless result == [[2, true], [1], [3, true], [4], [5]]
