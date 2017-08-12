# A Docker based Wordpress development environment

This is a starter development environment to get you up and running with your Wordpress development project 

## Getting Started

Clone this repo into a folder on your local machine 

### Prerequisites

You will need Docker installed on your local machine. 

### Installing

Here are the steps need to get this Docker up and running:

Clone the repo to a local folder on your machine: 

```
git clone git@github.com:ilibilibom/Docker-wordpress-ngnix-php-mysql-wpcli-mailcaher.git
```

Change the following variables to your own: 

1) in nginx/default.conf - change YOUR_SERVER_NAME to your server name (after adding a local domain to to your local host file). 

```
server {
  server_name server_name YOUR_SERVER_NAME;
  listen 80 default_server;

  root   /var/www/html;
  index  index.php index.html;

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
      - "jfrog.loc:YOUR_DOCKER_IP" # Use the gateway address for your docker network for the ip address. This is so that PHP FPM can find nginx for the postback to do things like cron jobs with WordPress
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

## Run Docker 

Run

```
docker-compose up -d 
```

## Install Wordpress

Your Wordpress install lives in the app folder. Remove the gitkeep file there, and start your wordpress installation. 

## WP CLI 

You can run Wp cli through docker. 
To run wp cli commands run (replace YOUR_CLI_COMMAND with a real command - for example user list): 
 
 ```
 docker exec -u www-data mysite_phpfpm_1 wp YOUR_CLI_CMMAND 
 ```
 


## Built With

* [Docker](http://www.docker.com) - Docker 


## Authors

* **Ilan Diamond** - follow me on Twitter @ilibilibom


## License

Feel free to do what ever you wish with this code :) 



