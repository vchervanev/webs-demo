class SpeakerLoader

  ATTRS_BASIC = %i(id company importance last_name thumbnail_url interests title country first_name)
  ATTRS_DETAILS = ATTRS_BASIC + %i(bio image_url)
  DEFAULTS = { page_size: 25 }

  def self.details(id)
    values = REDIS.hmget("speaker/#{id}", ATTRS_DETAILS)
    values_to_hash(ATTRS_DETAILS, values)
  end

  def self.load_all(ids)
    data = REDIS.multi do
      ids.each do |id|
        REDIS.hmget("speaker/#{id}", ATTRS_BASIC)
      end
    end

    data.map { |values| values_to_hash(ATTRS_BASIC, values)}
  end

  def self.queues
    REDIS.keys('targeted_queues/*').map { |q| q.scan(/targeted_queues\/(.+)/)[0][0] }
  end

  def self.ids(queue, first, last)
    REDIS.lrange(self.queue_id(queue), first, last)
  end

  def self.load_queue(queue, first, last)
    load_all(ids(queue, first, last))
  end

  # returns [first, last, page_count, page]
  def self.limits(queue, page, page_size)
    if page.nil?
      first, last, page_count, page_size = 0, -1, 1, 1
    else
      page_size ||= DEFAULTS[:page_size]
      page_count = (queue_len(queue) / page_size).ceil
      first = (page-1)*page_size
      last = page*page_size-1
    end
    [first, last, page_count, page_size]
  end

  def self.queue_len(queue)
    REDIS.llen(self.queue_id(queue))
  end

  private

  def self.queue_id(queue_name)
    (queue_name.nil? || queue_name.empty?) ? "general_queue" : "targeted_queues/#{queue_name}"
  end

  def self.values_to_hash(names, values)
    Hash[names.zip(values)]
  end

end
