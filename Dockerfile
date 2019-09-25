FROM ubuntu:xenial

MAINTAINER furiousgeorge <furiousgeorgecode@gmail.com>

ENV INSTALL_LIST apache2 php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-gd php7.0-intl ffmpeg libimage-exiftool-perl python git curl python-pip wget zip  libbz2-dev libmemcached-dev libsasl2-dev libfreetype6-dev libicu-dev libjpeg-dev libmemcachedutil2 libpng-dev libxml2-dev libimage-exiftool-perl

RUN apt-get update \
    && apt-get install -qy $INSTALL_LIST \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /root/.cache \
    && a2enmod rewrite

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
