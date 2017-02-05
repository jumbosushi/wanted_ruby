require 'pry'
require 'sinatra'
set :public_folder, 'public'

before do
  request.body.rewind
  @request_payload = JSON.parse request.body.read
end

get '/' do
  redirect '/index.html'
end

post '/get_wanted' do
  require 'data_uri'

  binding.pry
  puts @request_payload
  uri = URI::Data.new(@request_payload)
  File.write('uploads/file.jpg', uri.data)
end
