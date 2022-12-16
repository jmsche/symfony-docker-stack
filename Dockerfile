FROM debian:11

RUN apt update  \
    && apt -y install apt-transport-https lsb-release ca-certificates wget \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg  \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'  \
    && apt update  \
    && apt upgrade -y

RUN apt-get update -yqq && apt-get install git vim curl wget libzip-dev zip rsync redis-server imagemagick \
    php8.2-mysql php8.2-mbstring php8.2-curl php8.2-gd php8.2-imagick php8.2-intl \
    php8.2-redis php8.2-simplexml php8.2-zip php8.2-xdebug \
    -yqq

RUN cd ~ \
    && curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && apt install -y nodejs

RUN npm install -g yarn

ENV PATH="${PATH}:~/.composer/vendor/bin"
