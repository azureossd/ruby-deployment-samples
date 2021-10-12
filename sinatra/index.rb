require 'sinatra'
 class MyApp < Sinatra::Application
 get '/' do
   'Hello world from Sinatra!'
 end
end
