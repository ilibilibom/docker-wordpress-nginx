FROM php:7.1-fpm

ARG INSTALL_XDEBUG=true
ENV INSTALL_XDEBUG ${INSTALL_XDEBUG}
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    pecl install xdebug && \
    docker-php-ext-enable xdebug \
;fi

COPY php.ini /usr/local/etc/php/conf.d/uploads.ini
RUN apt-get update && apt-get install -y libz-dev libmemcached-dev libjpeg-dev libpng-dev
RUN docker-php-ext-install -j$(nproc) pdo pdo_mysql mysqli gd
RUN docker-php-ext-enable pdo pdo_mysql mysqli gd

RUN docker-php-ext-install zip
RUN docker-php-ext-enable zip

RUN curl https://getcomposer.org/download/1.2.0/composer.phar > /tmp/composer.phar \
    && chmod +x /tmp/composer.phar \
    && mv /tmp/composer.phar /usr/local/bin/composer \
    && apt-get update && apt-get install -y less \
    && curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /tmp/wp-cli.phar \
    && chmod +x /tmp/wp-cli.phar \
    && mv /tmp/wp-cli.phar /usr/local/bin/wp

CMD ["php-fpm"]

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN /usr/local/bin/docker-entrypoint.sh

USER www-data

EXPOSE 9000