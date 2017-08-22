# A Docker based Wordpress development environment

This is a starter development environment to get you up and running with your Wordpress development project 


This Docker install contains the following features: 
 1) Ngnix 
 2) PHPfpm
 3) Mysql (Maria DB)
 4) Composer
 5) WP CLI
 6) Mailcacher   
 7) Xdebug 
 8) Self generated SSL certificate (Only for development)


### Prerequisites

You will need Docker installed on your local machine. 

### Installing

Here are the steps need to get this project up and running:

Clone the repo to a local folder on your machine: 

```
git clone git@github.com:ilibilibom/Docker-wordpress-ngnix-php-mysql-wpcli-mailcaher.git
```

Change the following variables to your own: 

1) in nginx/default.conf - change YOUR_DOMAIN to your server name (after adding a local domain to to your local host file). 

```
server {
  listen 443 ssl;
  listen 80 ;

  server_name YOUR_DOMAIN;

  ssl_certificate      /etc/certs/nginx.crt;
  ssl_certificate_key  /etc/certs/nginx.key;

  root   /var/www/html;
  index  index.php;

  access_log /dev/stdout;
  error_log /dev/stdout info;

  location / {
    try_files $uri $uri/ /index.php?$args;
  }

  location ~ .php$ {
    include fastcgi_params;
    fastcgi_pass phpfpm:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
  }

  sendfile off;
}
```

In docker-compose.yml file change:
1) YOUR_ROOT_PASSWORD
2) YOUR_DB_NAME
3) YOUR_DB_USER
4) YOUR_DB_PASSWORD
5) YOUR_DOCKER_IP

```
version: '2'
services:
  mysql:
    image: mysql:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: YOUR_ROOT_PASSWORD
      MYSQL_DATABASE: YOUR_DB_NAME
      MYSQL_USER: YOUR_DB_USER
      MYSQL_PASSWORD: YOUR_DB_PASSWORD
    ports:
      - "3306:3306"
    volumes:
      - "./.data/mysql:/var/lib/mysql"
  phpfpm:
    depends_on:
      - mysql
    image: my/phpfpm:latest
    build: ./docker/php-fpm
    volumes:
      - "./app:/var/www/html"
      - "./docker/php-fpm/php.ini:/usr/local/etc/php/php.ini"
      - "./docker/php-fpm/xdebug.ini:/usr/local/etc/php/conf.d/xdebug.ini"
    links:
      - mysql
      - mailcatcher
    restart: always
    extra_hosts:
      - "YOUR_DOMAIN:YOUR_DOCKER_IP" # Use the gateway address for your docker network for the ip address. This is so that PHP FPM can find nginx for the postback to do things like cron jobs with WordPress
  nginx:
    depends_on:
      - phpfpm
    ports:
      - "80:80"
    image: nginx:latest
    volumes:
      - "./app:/var/www/html"
      - "./docker/nginx/default.conf:/etc/nginx/conf.d/default.conf"
    links:
      - phpfpm
    restart: always
  mailcatcher:
      image: yappabe/mailcatcher
      ports:
          - 1025:1025
          - 1080:1080

```

IMPORTANT - YOUR_DB_NAME, YOUR_DB_USER, YOUR_DB_PASSWORD are the values you add to your wp-config.php file 
 
ALSO - DB_HOST in your wp-config.php file should be - "mysql"

## Run Docker 

Run

```
docker-compose build

docker-compose up -d 
```

Now go to your local domain (or your docker ip - if you didn't add a domain to your host file) - you should see the following message: 

```
Yeh !! - Install your PHP aplication here
```


## Install Wordpress

Your Wordpress install lives in the ` app ` folder. 
This is where you start your wordpress installation. 

## WP CLI 

You can run Wp cli through docker. 
To run wp cli commands run (replace YOUR_PHPFRM_CONTAINER_NAME - you can find it by running docker ps) and ( YOUR_CLI_COMMAND ) with a real command - for example core download): 
 
 ```
 docker exec -u www-data YOUR_PHPFRM_CONTAINER_NAME wp YOUR_CLI_CMMAND 
 ```

 for example 
  ```
  docker exec -u www-data YOUR_PHPFRM_CONTAINER_NAME wp core download 
  ```
 
 
 You can also add this command to your alias so you can have a shorter version of the command
  
 Go to bash_profile file
  ```
   cd && sudo nano .bash_profile
 ```
 Add an alias 
   ```
alias wp_docker='docker exec -u www-data wp8_phpfpm_1 wp'    

  ```
 Exit file and refresh your terminal 
 
 ```
 source ~/.bash_profile
 ```

 Now you can run wp_docker instead of the previous long command. 
 
 
  ## Mail Cacher 
  
  Mail Cacher should be running on http://YOUR_DOMAIN:1080 
  
 
 ## Pull requests 
 
 Most welcome !! 



## Built With

* [Docker](http://www.docker.com) - Docker 


## Authors

* **Ilan Diamond** - follow me on Twitter @ilibilibom


## License

Feel free to do what ever you wish with this code :) 



