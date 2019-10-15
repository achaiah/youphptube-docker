# Based on the work of @hannah98, thanks for that!
# https://github.com/hannah98/youphptube-docker
# Licensed under the terms of the CC-0 license, see
# https://creativecommons.org/publicdomain/zero/1.0/deed

FROM php:7-apache

ENV INSTALL_LIST nano wget git zip default-libmysqlclient-dev libbz2-dev libmemcached-dev libsasl2-dev libfreetype6-dev libicu-dev libjpeg-dev libmemcachedutil2 libpng-dev libxml2-dev mariadb-client ffmpeg libimage-exiftool-perl python curl python-pip libzip-dev

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y software-properties-common
RUN apt-get install -qy $INSTALL_LIST \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include && \
    docker-php-ext-install -j$(nproc) bcmath bz2 calendar exif gd gettext iconv intl mbstring mysqli opcache pdo_mysql zip && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /root/.cache && \
    a2enmod rewrite

RUN echo "post_max_size = 10240M\nupload_max_filesize = 10240M\nallow_url_fopen = On\nallow_url_include = On" >> /usr/local/etc/php/php.ini

WORKDIR /var/www/html

RUN cd /var/www/html \
    && git clone https://github.com/DanielnetoDotCom/YouPHPTube.git . \
    && pip install -U youtube-dl \
    && git clone https://github.com/DanielnetoDotCom/YouPHPTube-Encoder.git encoder

# fix permissions
RUN chown -R www-data /var/www/html

ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
