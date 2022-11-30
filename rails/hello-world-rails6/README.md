# How to run this example with Docker

**You need Ruby 2.7.3 to run this sample**

1. Create a secret for compiling assets with the following command: `bundle exec rake secret`
2. Copy this secret to your notepad, since you will use this for the docker build command.
3. Build the image with the following command, replace <> with your values: `docker build --build-arg SECRET=<yourCopiedSecret> -t <imagename>:<tag> .`
4. To run the container, you need to pass the environment variable secret with the following command: `docker run -d -e SECRET_KEY_BASE=<yourCopiedSecret> -p 3000:3000 <imagename>:<tag>`
 
