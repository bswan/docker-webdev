FROM ubuntu:16.04
MAINTAINER Jason Zhang <jason.zhang@internetrix.com.au>
ARG DEBIAN_FRONTEND=noninteractive

### Change to default mirror to AU mirror - https://wiki.ubuntu.com/AustralianTeam/LocalAptMirrors#Australian_Mirrors
RUN sed -i -e 's/http:\/\/archive./http:\/\/au.archive./g' /etc/apt/sources.list
RUN sed -i -e 's/http:\/\/releases./http:\/\/au.releases./g' /etc/apt/sources.list

### SET UP
RUN apt-get -qq update

# Supporting tools
RUN apt-get -qqy install sudo wget telnet nano vim curl make git bzip2 zip unzip gettext-base locales cifs-utils software-properties-common dnsutils iputils-ping net-tools mailutils

RUN echo "LANG=en_US.UTF-8\n" > /etc/default/locale && \
	echo "en_US.UTF-8 UTF-8\n" > /etc/locale.gen && \
	locale-gen
	
ENV ENV LANG en_US.UTF-8

# APACHE 
RUN apt-get -qqy install apache2 

## Multi PHP Version Support
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get -qq update

RUN apt-get -qqy upgrade

# PHP 5.6
RUN apt-get -qqy install php5.6 php5.6-cli php5.6-fpm php5.6-mysql php5.6-common php5.6-curl php5.6-soap php5.6-gd php5.6-mcrypt php5.6-tidy php5.6-mbstring php5.6-xml php5.6-intl php5.6-memcache

RUN echo "date.timezone = Australia/Sydney" > /etc/php/5.6/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/5.6/fpm/conf.d/timezone.ini
	
# PHP 7.0
RUN apt-get -qqy install php7.0 php7.0-cli php7.0-fpm php7.0-mysql php7.0-curl php7.0-soap php7.0-common php7.0-gd php7.0-mcrypt php7.0-tidy php7.0-mbstring php7.0-xml php7.0-intl php7.0-memcache
	
RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.0/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.0/fpm/conf.d/timezone.ini
	
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
	mv composer.phar /usr/local/bin/composer && \
	
# NodeJS and common global NPM modules
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
	apt-get install -qqy npm nodejs && \
	npm install -g grunt-cli gulp bower