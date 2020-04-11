ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine
LABEL Description="Application container"
## Looked here: <https://github.com/prooph/docker-files/blob/master/php/7.2-cli>
ENV PS1='\[\033[1;32m\]  \[\033[1;36m\][\u@\h] \[\033[1;34m\]\w\[\033[0;35m\] \[\033[1;36m\]# \[\033[0m\]'

# persistent / runtime deps
ENV PHPIZE_DEPS \
    autoconf \
    cmake \
    file \
    g++ \
    gcc \
    libc-dev \
    pcre-dev \
    make \
    pkgconf \
    re2c \
    # for GD
    freetype-dev \
    libpng-dev  \
    libjpeg-turbo-dev \
    libxslt-dev

RUN apk add --no-cache --virtual .persistent-deps \
    # for intl extension
    icu-dev \
    # for postgres
    postgresql-dev \
    # for soap
    libxml2-dev \
    # for GD
    freetype \
    libpng \
    libjpeg-turbo \
    # for bz2 extension
    bzip2-dev \
    # for intl extension
    libintl gettext-dev libxslt \
    # etc
    bash \
    nano \
    git

RUN apk add --no-cache libpng-dev zlib-dev libzip-dev \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install zip

RUN set -xe \
    # workaround for rabbitmq linking issue
    && ln -s /usr/lib /usr/local/lib64 \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure mysqli --with-mysqli \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure pdo_pgsql --with-pgsql \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-configure soap --enable-soap \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install -j$(nproc) \
        zip \
        gd \
        bcmath \
        intl \
        pcntl \
        mysqli \
        pdo_mysql \
        pdo_pgsql \
        mbstring \
        soap \
        iconv \
        bz2 \
        calendar \
        exif \
        gettext \
        shmop \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        wddx \
        xsl \
        opcache \
    && echo -e "opcache.memory_consumption=128\n\
opcache.interned_strings_buffer=8\n\
opcache.max_accelerated_files=4000\n\
opcache.revalidate_freq=60\n\
opcache.fast_shutdown=1\n\
opcache.enable_cli=1\n\
opcache.enable=1\n" > /usr/local/etc/php/conf.d/opcache.ini

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

ENV PHP_REDIS_VERSION 5.1.1
RUN git clone --branch ${PHP_REDIS_VERSION} https://github.com/phpredis/phpredis /tmp/phpredis \
        && cd /tmp/phpredis \
        && phpize  \
        && ./configure  \
        && make  \
        && make install \
        && make test \
        && echo 'extension=redis.so' > /usr/local/etc/php/conf.d/redis.ini

RUN rm -rf /tmp/* \
    && rm -rf /scripts \
    && mkdir /scripts \
    && mkdir -p /scripts/aliases \
    && rm -rf /home/user \
    && mkdir /home/user \
    && chmod 777 /home/user \
    && rm -f /docker-entrypoint.sh \
    && rm -f /usr/local/etc/php-fpm.d/*

COPY ./etc/php/php.ini /usr/local/etc/php/php.ini
COPY ./etc/php/php-fpm.conf /usr/local/etc/php-fpm.conf

ENV PATH /scripts:/scripts/aliases:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /home/user
ENV COMPOSER_VERSION 1.9.0
RUN set -xe \
    && mkdir -p "$COMPOSER_HOME" \
    # install composer
    && php -r "copy('https://getcomposer.org/installer', '/home/user/composer-setup.php');" \
    && php /home/user/composer-setup.php --no-ansi --install-dir=/usr/bin --filename=composer --version=$COMPOSER_VERSION \
    && composer --ansi --version --no-interaction \
    && composer --no-interaction global require 'hirak/prestissimo' \
    && composer clear-cache \
    && rm -rf /home/user/composer-setup.php /home/user/.htaccess \
    # show php info
    && php -v \
    && php-fpm -v \
    && php -m

ARG INSTALL_MEMCACHED=false
ENV MEMCACHED_DEPS libmemcached-dev
RUN if [ ${INSTALL_MEMCACHED} = true ]; then \
    apk add --no-cache --update libmemcached-libs zlib \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && set -xe \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
    && rm -rf /usr/share/php7 \
    && rm -rf /tmp/* \
    && apk del .memcached-deps \
;fi

RUN apk del .build-deps

COPY ./keep-alive.sh /scripts/keep-alive.sh
COPY ./scheduler.sh /scripts/scheduler.sh
COPY ./fpm-entrypoint.sh /fpm-entrypoint.sh
COPY ./wait-for-it.sh /wait-for-it.sh
COPY ./aliases/* /scripts/aliases/

RUN chmod +x -R /scripts/
RUN chmod +x /fpm-entrypoint.sh
RUN chmod +x /wait-for-it.sh

WORKDIR /var/www
ENTRYPOINT []
CMD []
