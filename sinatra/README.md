# How to run this app

1. Install gem dependencies with `bundle install`
2. Run sinatra app with `ruby index.rb -o 0.0.0.0 -p 3000`
. Browse the site on `http://localhost:3000`


# How to run this app with Docker

1. Build the image with `docker build -t <image>:<tag> .`
2. Run the container with `docker run -d -p 4567:4567 <image>:<tag>`
