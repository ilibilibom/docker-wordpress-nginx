FROM nginx

COPY docker-nginx-entrypoint.sh /usr/local/bin/docker-nginx-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-nginx-entrypoint.sh

RUN /usr/local/bin/docker-nginx-entrypoint.sh

COPY /certs/* /etc/certs/