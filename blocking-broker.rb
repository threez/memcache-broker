require "rubygems"
require "sinatra"
require "memcache"

CACHE = MemCache.new 'localhost'

get "/:name" do
  name = params[:name]
  CACHE.get(name)
end

post "/:name" do
  request.body.rewind  # in case someone already read it
  data = request.body.read
  puts " set #{params[:name]} => #{data}"
  CACHE.set(params[:name], data)
  "STORED\n"
end
