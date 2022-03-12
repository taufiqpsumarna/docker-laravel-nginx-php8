# Debian 11 - nginx stable
FROM nginx:latest

# Deklarasi Working Directory dan Copy Content menuju kontainer
WORKDIR /usr/share/nginx/html/
COPY . .

#Install Paket Depedensi Untuk Laravel
## Update Repo
RUN apt update

### Install PHP 8.0
RUN apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2 wget
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list 
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
RUN apt update
RUN apt install curl unzip git openssl php8.0-{common,cli,curl,mbstring,mysql,xml,zip} -y

#Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer && chmod +x /usr/local/bin/composer

#Inisiasi Project Laravel
RUN -C "composer install && composer update"
RUN -C "php artisan -S 0.0.0.0:8080
