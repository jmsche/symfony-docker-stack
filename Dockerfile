FROM php:7.1

RUN curl -sL http://deb.nodesource.com/setup_6.x | bash - && \
    curl -sS http://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -yqq && \
    apt-get install -yqq --force-yes git unzip nodejs yarn libicu-dev && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    docker-php-ext-install bcmath pdo pdo_mysql intl && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 

# Memcached # TODO PECL not available for PHP 7 yet, we must compile it
RUN apt-get update \
	&& apt-get install -y \
	libmemcached-dev \
	libmemcached11
RUN cd /tmp \
	&& git clone -b php7 https://github.com/php-memcached-dev/php-memcached \
	&& cd php-memcached \
	&& phpize \
	&& ./configure \
	&& make \
	&& cp /tmp/php-memcached/modules/memcached.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303/memcached.so \
	&& docker-php-ext-enable memcached
