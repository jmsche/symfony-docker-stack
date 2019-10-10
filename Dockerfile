FROM php:7.3

RUN apt-get update && apt-get install -my wget gnupg # Fixes NodeJS key repo
RUN curl -sL http://deb.nodesource.com/setup_8.x | bash - && \
    curl -sS http://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -yqq && \
    apt-get install -yqq --force-yes git unzip nodejs yarn libicu-dev libxml2-dev zlib1g-dev && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    docker-php-ext-install bcmath pdo pdo_mysql intl && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    pecl install -o -f redis && \
    rm -rf /tmp/pear && \
    docker-php-ext-enable redis

RUN apt-get update && apt-get install -y \
        libmemcached11 \
        libmemcachedutil2 \
        libmemcached-dev \
        libz-dev \
        libzip-dev \
        git \
    && cd /root \
    && git clone https://github.com/php-memcached-dev/php-memcached \
    && cd php-memcached \
    && git checkout tags/v3.1.3 \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -rf  php-memcached \
    && echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini \
    && apt-get remove -y build-essential libmemcached-dev libz-dev \
    && apt-get remove -y \
        libmemcached-dev \
        libz-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# ImageMagick
RUN apt-get update && \
    apt-get install -y --no-install-recommends libmagickwand-dev && \
    rm -rf /var/lib/apt/lists/*

RUN pecl install imagick-3.4.3 && \
    docker-php-ext-enable imagick

# GD
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

RUN docker-php-ext-install ctype
RUN docker-php-ext-install zip
RUN docker-php-ext-install iconv
RUN docker-php-ext-install dom
#RUN docker-php-ext-install libxml
RUN docker-php-ext-install simplexml
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install xml
#RUN docker-php-ext-install xmlreader
#RUN docker-php-ext-install xmlwriter
#RUN docker-php-ext-install zlib
