require 'sinatra'
set :port, 4000

post '/get_wanted' do
  require 'data_uri'

  binding.pry
  puts @request_payload
  uri = URI::Data.new(@request_payload)
  File.write('uploads/file.jpg', uri.data)
end
