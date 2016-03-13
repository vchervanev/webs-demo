require 'bundler/setup'
Bundler.require

require_relative 'init'
require_relative 'speaker_loader'
require 'json'

def safe_to_i(v)
  v && v.to_i
end

get '/' do
  haml :index, layout: :default
end

get '/speakers' do
  content_type :json

  page_number = safe_to_i(params['page'])
  page_size = safe_to_i(params['page_size'])
  interest = params['interest']

  first, last, page_count, page_size = SpeakerLoader.limits(interest, page_number, page_size)

  speakers = SpeakerLoader.load_queue(interest, first, last).map(&:to_json).join(",\n")

  meta = {
      page: page_number,
      total_pages: page_count,
      page_size: page_size
  }

  "{ \"meta\": #{meta.to_json}, \"data\": {\"speakers\": [#{speakers}]} }"
end

get '/speakers/:id' do |id|
  content_type :json

  SpeakerLoader.details(id).to_json
end

get '/interests' do
  content_type :json

  SpeakerLoader.queues.to_json
end

get '/view/:view' do |view|
  path = File.join('public', view)
  if File.exist?(File.join(File.dirname(__FILE__), 'views', path + '.haml'))
    haml path.to_sym, layout: nil
  else
    404
  end
end
