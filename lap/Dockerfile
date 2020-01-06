FROM ubuntu:16.04
MAINTAINER Jason Zhang <jason.zhang@internetrix.com.au>
ARG DEBIAN_FRONTEND=noninteractive

### Change to default mirror to AU mirror - https://wiki.ubuntu.com/AustralianTeam/LocalAptMirrors#Australian_Mirrors
RUN cp /etc/apt/sources.list /etc/apt/sources.list.origin && \
	sed -i -e 's/http:\/\/archive./http:\/\/au.archive./g' /etc/apt/sources.list && \
	sed -i -e 's/http:\/\/releases./http:\/\/au.releases./g' /etc/apt/sources.list

### SET UP
RUN apt-get -qq update

# Supporting tools
RUN apt-get -qqy install sudo wget telnet nano vim curl make git bzip2 zip unzip gettext-base locales cifs-utils software-properties-common dnsutils iputils-ping net-tools mailutils mariadb-client

RUN echo "LANG=en_US.UTF-8\n" > /etc/default/locale && \
	echo "en_US.UTF-8 UTF-8\n" > /etc/locale.gen && \
	locale-gen
	
ENV ENV LANG en_US.UTF-8

# APACHE
RUN apt-get -qqy install apache2 

## Stable PHP Versions - 5.6 | 7.0 | 7.1 | 7,2
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
## Old PHP Versions - 5.3 | 5.4 | 5.5
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:sergey-dryabzhinsky/packages
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:sergey-dryabzhinsky/php53
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:sergey-dryabzhinsky/php54
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:sergey-dryabzhinsky/php55

RUN apt-get -qq update

RUN apt-get -qqy upgrade

# PHP 7.4
RUN apt-get -qqy install php7.4 php7.4-cli php7.4-fpm php7.4-mysql php7.4-curl php7.4-soap php7.4-common php7.4-gd php7.4-tidy php7.4-mbstring php7.4-xml php7.4-intl php7.4-memcache php7.4-yaml php7.4-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.4/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.4/fpm/conf.d/timezone.ini

# PHP 7.3
RUN apt-get -qqy install php7.3 php7.3-cli php7.3-fpm php7.3-mysql php7.3-curl php7.3-soap php7.3-common php7.3-gd php7.3-tidy php7.3-mbstring php7.3-xml php7.3-intl php7.3-memcache php7.3-yaml php7.3-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.3/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.3/fpm/conf.d/timezone.ini

# PHP 7.2
RUN apt-get -qqy install php7.2 php7.2-cli php7.2-fpm php7.2-mysql php7.2-curl php7.2-soap php7.2-common php7.2-gd php7.2-tidy php7.2-mbstring php7.2-xml php7.2-intl php7.2-memcache php7.2-yaml php7.2-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.2/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.2/fpm/conf.d/timezone.ini
	
# PHP 7.1
RUN apt-get -qqy install php7.1 php7.1-cli php7.1-fpm php7.1-mysql php7.1-curl php7.1-soap php7.1-common php7.1-gd php7.1-mcrypt php7.1-tidy php7.1-mbstring php7.1-xml php7.1-intl php7.1-memcache php7.1-yaml php7.1-zip
	
RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.1/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.1/fpm/conf.d/timezone.ini

# PHP 7.0
RUN apt-get -qqy install php7.0 php7.0-cli php7.0-fpm php7.0-mysql php7.0-curl php7.0-soap php7.0-common php7.0-gd php7.0-mcrypt php7.0-tidy php7.0-mbstring php7.0-xml php7.0-intl php7.0-memcache php7.0-yaml php7.0-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.0/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.0/fpm/conf.d/timezone.ini

# PHP 5.6
RUN apt-get -qqy install php5.6 php5.6-cli php5.6-fpm php5.6-mysql php5.6-common php5.6-curl php5.6-soap php5.6-gd php5.6-mcrypt php5.6-tidy php5.6-mbstring php5.6-xml php5.6-intl php5.6-memcache php5.6-yaml php5.6-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/5.6/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/5.6/fpm/conf.d/timezone.ini

# install PHP53, PHP54 zip extension deps
RUN apt-get -qqy install libzip-dev libpcre3-dev

# Old PHP 5.3
RUN apt-get -qqy install php53-cli php53-fpm php53-pecl php53-common php53-mod-openssl php53-mod-curl php53-mod-dom php53-mod-exif php53-mod-fileinfo php53-mod-gd php53-mod-mbstring php53-mod-gettext php53-mod-mysql php53-mod-ftp php53-mod-simplexml php53-mod-xmlreader php53-mod-xmlwriter php53-mod-tokenizer php53-mod-intl php53-mod-soap php53-mod-json

RUN echo "date.timezone = Australia/Sydney" > /etc/php53/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php53/fpm/conf.d/timezone.ini

## enable php53-fpm
RUN sed -i -e 's/#ENABLE=true/ENABLE=true/g' /etc/default/php53-fpm

## PHP53 zip.so
RUN pecl53 install zip
RUN echo "extension=zip.so" > /etc/php53/conf.d/zip.ini && \
    ln -s /etc/php53/conf.d/zip.ini /etc/php53/cli/conf.d/zip.ini && \
    ln -s /etc/php53/conf.d/zip.ini /etc/php53/fpm/conf.d/zip.ini

# Old PHP 5.4
RUN apt-get -qqy install php54-cli php54-fpm php54-pecl php54-common php54-mod-openssl php54-mod-curl php54-mod-dom php54-mod-exif php54-mod-fileinfo php54-mod-gd php54-mod-mbstring php54-mod-gettext php54-mod-mysql php54-mod-ftp php54-mod-simplexml php54-mod-xmlreader php54-mod-xmlwriter php54-mod-tokenizer php54-mod-intl php54-mod-soap php54-mod-json

RUN echo "date.timezone = Australia/Sydney" > /etc/php54/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php54/fpm/conf.d/timezone.ini

## enable php54-fpm
RUN sed -i -e 's/#ENABLE=true/ENABLE=true/g' /etc/default/php54-fpm

## PHP54 zip.so
RUN pecl54 install zip
RUN echo "extension=zip.so" > /etc/php54/conf.d/zip.ini && \
    ln -s /etc/php54/conf.d/zip.ini /etc/php54/cli/conf.d/zip.ini && \
    ln -s /etc/php54/conf.d/zip.ini /etc/php54/fpm/conf.d/zip.ini

# Old PHP 5.5
RUN apt-get -qqy install php55-cli php55-fpm php55-pecl php55-common php55-mod-openssl php55-mod-curl php55-mod-dom php55-mod-exif php55-mod-fileinfo php55-mod-gd php55-mod-mbstring php55-mod-gettext php55-mod-mysql php55-mod-ftp php55-mod-simplexml php55-mod-xmlreader php55-mod-xmlwriter php55-mod-tokenizer php55-mod-intl php55-mod-soap php55-mod-json

RUN echo "date.timezone = Australia/Sydney" > /etc/php55/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php55/fpm/conf.d/timezone.ini

## enable php55-fpm
RUN sed -i -e 's/#ENABLE=true/ENABLE=true/g' /etc/default/php55-fpm

# Apache & PHP Configuration
RUN echo "webdev is ok" > /var/www/html/index.html 

# Setup phpmyadmin
ADD apache-phpmyadmin.conf /etc/apache2/conf-available/phpmyadmin.conf

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.7.4/phpMyAdmin-4.7.4-all-languages.tar.gz && \
	tar xzf phpMyAdmin-4.7.4-all-languages.tar.gz -C /opt && \
	rm phpMyAdmin-4.7.4-all-languages.tar.gz && \
	mv /opt/phpMyAdmin-4.7.4-all-languages /opt/phpmyadmin && \
	a2enconf phpmyadmin.conf
	
# Add default phpmyadmin config
ADD phpmyadmin.config.inc.php /opt/phpmyadmin/config.inc.php

# Composer
RUN wget https://getcomposer.org/composer.phar && \
	chmod +x composer.phar && \
	mv composer.phar /usr/local/bin/composer
	
# NodeJS and common global NPM modules
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
	apt-get install -qqy nodejs && \
	npm install -g grunt-cli gulp bower

# Blackfire Debian repo setup
RUN wget -q -O - https://packagecloud.io/gpg.key | apt-key add - && \
    echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list

## Blackfire (PHP profiling) - install agent & PHP Probe
RUN apt-get -qq update && apt-get -qqy install -y --allow-unauthenticated blackfire-agent blackfire-php