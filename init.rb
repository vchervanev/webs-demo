require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'

require 'redis'
REDIS = Redis.new(url: ENV['REDIS_URL'])
