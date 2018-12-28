ARG PHP_TARGET_VERSION=7.2
# ATTENTION: 7.2 needs >= xdebug 2.6.1

FROM php:${PHP_TARGET_VERSION}-fpm

RUN apt update && apt install -y \
    nginx \
    bash \
    wget \
    nano \
    procps \
    libpq-dev \
#    libfreetype6-dev \
#    libjpeg62-turbo-dev \
#    libpng-dev \
#    libssl-dev \
#    g++ \
    && docker-php-ext-install -j$(nproc) pdo_pgsql && docker-php-ext-enable pdo_pgsql \
    && pecl install xdebug-2.6.1 && docker-php-ext-enable xdebug \
    && pecl install redis && docker-php-ext-enable redis  \
    && docker-php-source delete \
    && rm -rf /tmp/pear/* /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && rm -rf /etc/nginx/sites-enabled/default /var/www/html/*
COPY resources /

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -sf /dev/stderr /usr/local/var/log/php-fpm.log

RUN touch /var/log/xdebug.log && chgrp www-data /var/log/xdebug.log && chmod g+w /var/log/xdebug.log

EXPOSE 80

WORKDIR /

CMD ["/usr/local/bin/run-daemons.sh"]
