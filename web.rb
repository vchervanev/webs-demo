require 'bundler/setup'
Bundler.require

require_relative 'init'
require 'json'

get '/' do
  haml :index, layout: :default
end

get '/speakers.json' do
  content_type :json
  page = (params['page'] || 1).to_i
  page_size = (params['page_size'] || 25).to_i

  total_pages = (REDIS.llen('general_queue').to_f / page_size).ceil
  ids = REDIS.lrange('general_queue', (page-1)*page_size, page*page_size-1) || []
  speakers = REDIS.multi do
    ids.each do |id|
      REDIS.hgetall("speaker/#{id}")
    end
  end.map(&:to_json).join(",\n")

  "{ \"meta\": { \"page\": #{page}, \"total_pages\": #{total_pages} }, \"data\": {\"speakers\": [#{speakers}]} }"

end
