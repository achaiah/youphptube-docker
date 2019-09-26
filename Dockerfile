FROM ubuntu:xenial

MAINTAINER furiousgeorge <furiousgeorgecode@gmail.com>

ENV INSTALL_LIST apache2 php7.2 libapache2-mod-php7.2 php7.2-mbstring php7.2-mysql php7.2-curl php7.2-gd php7.2-intl php7.2-xml ffmpeg libimage-exiftool-perl python git curl python-pip wget zip libbz2-dev libmemcached-dev libsasl2-dev libfreetype6-dev libicu-dev libjpeg-dev libmemcachedutil2 libpng-dev libxml2-dev libimage-exiftool-perl

RUN apt-get update && apt-get upgrade
RUN apt-get install -y software-properties-common python-software-properties
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:jonathonf/ffmpeg-4
RUN apt-get update \
    && apt-get install -qy $INSTALL_LIST \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /root/.cache
RUN a2enmod php7.2 && a2enmod rewrite

WORKDIR /var/www/html

RUN cd /var/www/html \
    && rm -f index.html \
    && pip install --upgrade pip \
    && git clone https://github.com/DanielnetoDotCom/YouPHPTube.git . \
    && python -m pip install -U youtube-dl \
    && git clone https://github.com/DanielnetoDotCom/YouPHPTube-Encoder.git encoder

# fix permissions
RUN chown -R www-data /var/www/html

ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
