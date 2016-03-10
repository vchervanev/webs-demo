require 'sinatra/reloader' if development?

REDIS = Redis.new(url: ENV['REDIS_URL'])
