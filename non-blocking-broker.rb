require "rubygems"
require "sinatra"

AsyncResponse = [-1, {}, []].freeze

def memcache
  @@memcache ||= EM::P::Memcache.connect 'localhost', 11211
end

get "/:name" do
  name = params[:name].to_sym
  EventMachine.next_tick do
    memcache.get(name) do |value|
      env['async.callback'].call [200, {}, [value]]
    end
  end
  AsyncResponse
end

post "/:name" do
  request.body.rewind  # in case someone already read it
  data = request.body.read
  puts " set #{params[:name]} => #{data}"
  memcache.set(params[:name].to_sym, data)
  "STORED\n"
end
