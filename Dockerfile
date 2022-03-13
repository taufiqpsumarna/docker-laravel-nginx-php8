#reference: https://dev.to/jackmiras/laravel-with-php7-4-in-an-alpine-container-3jk6
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

# Installing PHP
RUN apk add --no-cache php8 \
    php8-common \
    php8-fpm \
    php8-pdo \
    php8-opcache \
    php8-zip \
    php8-phar \
    php8-iconv \
    php8-cli \
    php8-curl \
    php8-openssl \
    php8-mbstring \
    php8-tokenizer \
    php8-fileinfo \
    php8-json \
    php8-xml \
    php8-xmlwriter \
    php8-simplexml \
    php8-dom \
    php8-pdo_mysql \
    php8-pdo_sqlite \
    php8-tokenizer \
    php8-pecl-redis

RUN ln -s /usr/bin/php8 /usr/bin/php

# Installing composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php

# Building process
COPY . .
RUN composer install --no-dev
RUN php artisan migrate
RUN php artisan storage:link
RUN npm install
RUN npm run dev
#RUN chown -R nginx:nginx /usr/share/nginx/html

EXPOSE 80 8080
