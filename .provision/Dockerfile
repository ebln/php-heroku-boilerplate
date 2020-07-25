FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
    nginx \
    bash \
    wget \
    nano \
    unzip \
    procps \
    libpq-dev \
    libicu-dev \
    libcurl4-openssl-dev \
#    libonig-dev \
#    libsodium-dev \
#    libfreetype6-dev \
#    libjpeg62-turbo-dev \
#    libpng-dev \
#   @see https://hub.docker.com/_/php/#php-core-extensions
#   installing intl for symfony bcmath for laravel (consider soap for phpunit) curl
#   already installed: mbstring sodium
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) bcmath curl intl opcache sockets  \
    && docker-php-ext-install -j$(nproc) pdo_pgsql \
    && pecl install -o xdebug-2.9.2 && docker-php-ext-enable xdebug \
    && pecl install -o redis && docker-php-ext-enable redis  \
    && pecl install -o igbinary && docker-php-ext-enable igbinary  \
    && pecl install -o ds && docker-php-ext-enable ds  \
    && pecl install -o apcu && docker-php-ext-enable apcu \
    # && docker-php-source delete \
    && rm -rf /tmp/pear/* /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && rm -rf /etc/nginx/sites-enabled/default /var/www/html/*
COPY resources /

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -sf /dev/stderr /usr/local/var/log/php-fpm.log \
    && cd /usr/local/bin/ && /usr/local/bin/install-composer.sh && mv composer.phar composer \
    && composer global require friendsofphp/php-cs-fixer \
    && wget https://get.symfony.com/cli/installer -O /usr/local/bin/install-symfony.sh \
    && sed -i -e '/alias l\|export\|eval/s/# //' /root/.bashrc

ENV PATH "$PATH:/root/.composer/vendor/bin"
ENV SHELL "/bin/bash"

RUN touch /var/log/xdebug.log && chgrp www-data /var/log/xdebug.log && chmod g+w /var/log/xdebug.log

EXPOSE 80

WORKDIR /var/www/

CMD ["/usr/local/bin/run-daemons.sh"]
