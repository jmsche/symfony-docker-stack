FROM php:7.1

RUN curl -sL http://deb.nodesource.com/setup_6.x | bash - && \
    curl -sS http://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -yqq && \
    apt-get install -yqq --force-yes git unzip nodejs yarn && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    docker-php-ext-install bcmath pdo pdo_mysql && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 
