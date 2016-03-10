require_relative 'init'

get '/' do
  @data = REDIS.lrange('sample_list', 0, -1) || []
  haml :index, layout: :default
end
