# Creating Ruby on Rails site
1. Install the following gems in the shell

   ```bash
    gem install rails -v 5.2.6
    gem install rails -v 6.1.4.1
    gem install bundler -v 2.1.4
   ```

2. List the installed gems with:

   ```bash
    gem list rails
    gem list bundler
   ```

3. Create a new rails 5.2.6 site with **`rails _5.2.6_ new <name>`**
4. Cd into `<name>` directory and serve the app.
5. You can start your server with the following commands:
   - `rails server` or with `bundle exec rails server`: This will start your server with localhost:3000 but it will just listening on localhost and not all ip addresses, if you are requesting from outside your dev environment it will not reach the server.
   - `rails server -b 0.0.0.0`: This will start your server binding all ip addresses and use port 3000 (default port)
   - `rails server -b 0.0.0.0 -p <port>` : This will start your server binding all ip addresses and use a custom port.
6. Browse to `http://localhost:3000` and get the home page.

# Creating a MVC Blog with scaffold
1. A scaffold is a set of automatically generated files which forms the basic structure of a Rails project. You can use a scaffold template which contains a controller, mode and view for every action (index, edit, show, new) and a new route. 
   Create a Post structure with **`rails g scaffold Post title:string body:text`**
2. Since SQLite3 is by default configured in Rails, you can prepare your database and create an schema with **`rails db:migrate`**
3. Run your application with **`rails server -b 0.0.0.0`** and browse to `http://localhost:3000/posts`, you can add several posts, modify and delete.

# Integrating Disk Storage
1. Active Storage facilitates uploading files to different services, by default it is configured to disk. There are several requirements depending on the Rails version that you are using, please run the following commands to prepare the app for storage:
   - Install imagemagick with **`sudo apt-get install -y imagemagick`**   
   - Install Active Storage with **`rails active_storage:install`**
   - Modify your **Gemfile** file and add the following gem: **`gem 'mini_magick', '~> 4.8'`**
   - Run **`bundle install`** to install mini_magick gem.
2. Add the following content to file **`app/models/post.rb`**
   
   ```ruby
   class Post < ApplicationRecord
     has_one_attached :header_image
   end
   ```
 
   >This type specifies the relation between a single attachment and the model.

3. Modify function **`post_params`** inside this file **`app/controllers/posts_controller.rb`** and add the new parameter:
   
   ```ruby
   def post_params
     params.require(:post).permit(:title, :body, :header_image)
   end
   ```

4. Add the field inside this file **`app/views/posts/_form.html.erb`** 

   ```html
   <div class="field">
     <%= form.label :header_image %>
     <%= form.file_field :header_image %>
   </div>

   ```


5. Add these lines between the Title and the Body inside this file **`app/views/posts/show.html.erb`**
  
   ```html
   <% if @post.header_image.attached? then %>
     <p>
       <%= image_tag @post.header_image.variant(resize: "600x500") %>
     </p>
   <% else %>
     <p> No header image. </p>
   <% end %>
   ```

6. Add the following configuration under **`config/environments/development.rb`**
   ```ruby
   config.active_storage.replace_on_assign_to_many = false
   ```

   > *config.active_storage.replace_on_assign_to_many* determines whether assigning to a collection of attachments declared with has_many_attached replaces any existing attachments or appends to them. The default is true.

7. By default the files will be save on storage/ folder, you can cat storage config file with **`cat config/storage.yml`**, you can configure here other services as Azure Blob Storage as an example, by default is set to local disk as followed:

   ```ruby
   local:
     service: Disk
     root: <%= Rails.root.join("storage") %>
   ```

8. Last step it is to modify and add a route to this post action, modify file **`config/routes.rb`** and add the following line:
   
   ```ruby

    Rails.application.routes.draw do
      resources :posts
      root 'posts#index'
      # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    end
    ```

9. Run the server `rails server -b 0.0.0.0` and browse the site to `http://localhost:3000`. Add some posts uploading images and see the storage folder structure.


# Integrate MySQL database with your Rails app

1. Install Docker with the following commands one by one. If you have already docker skip these steps:

   ```bash
   sudo apt update

   sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

   sudo apt update

   apt-cache policy docker-ce

   sudo apt-get install -y docker-ce docker-ce-cli containerd.io

   echo $(docker -v)

   sudo groupadd docker

   sudo usermod -aG docker $USER

   sudo usermod -aG sudo $USER

   sudo systemctl start docker
   
   sudo su
   
   su <youruser>

   ```

2. Spin a MySQL Docker container with the following command: **`docker run --rm --name mysqldocker -e MYSQL_ROOT_PASSWORD=password -e MYSQL_USER=azure -e MYSQL_PASSWORD=anotherpassword -e MYSQL_DATABASE=blog -v /db:/var/lib/mysql -d -p 3306:3306 mysql:5.6.50`**
3. By default it will create a blog database, you can use mysql shell and show the databases with **`docker exec -i mysqldocker sh -c 'exec mysql --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --execute="SHOW DATABASES;"'`**
4. Install the mysql client with **`sudo apt-get install -y libmysqlclient-dev`**
5. Modify your Gemfile and add this gem **`gem 'mysql2', '~> 0.5.2'`**
6. Run **`bundle install`** to install the mysql2 gem.
7. Modify the following file **`config/database.yml`** and comment all the lines, at the end just add the following content:

   ```ruby
   default: &default
     adapter: mysql2
     encoding: utf8
     pool: 5
     database: <%= ENV['DB_NAME'] %>
     username: <%= ENV['DB_USER'] %>
     password: <%= ENV['DB_PASSWORD'] %>
     host: <%= ENV['DB_HOST'] %>

   development:
     <<: *default

   test:
     <<: *default

   production:
     <<: *default
   ```

8. Set the environment variables with the following values:

   ```bash
   export DB_NAME=blog
   export DB_USER=azure
   export DB_PASSWORD=anotherpassword
   export DB_HOST=127.0.0.1
   ```

9. Then create the new database schema with **`rake db:migrate`**
10. You can check the new tables created under blog database with **`docker exec -i mysqldocker sh -c 'exec mysql --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --execute="SHOW TABLES FROM blog;"'`**
11. Run your application with **`rails server -b 0.0.0.0`** and add some new posts.
12. You can check the new posts added inside the database with **`docker exec -i mysqldocker sh -c 'exec mysql --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --execute="use blog; SELECT *FROM posts;"'`**

