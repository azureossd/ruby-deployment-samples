# How to run this app
1. Install all gem dependencies with `bundle install`
2. Since Grape is designed to run on Rack or complement existing web application frameworks as Sinatra or Rails, you can use rackup to spin a quick server with `bundle exec rackup -o 0.0.0.0 -p 3000`

3. Browse to `http://localhost:3000/api/hello`
