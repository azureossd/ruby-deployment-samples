require 'sinatra'
require 'geocoder'

get '/' do
  'You are coming from here: ' + request.location.inspect
end
