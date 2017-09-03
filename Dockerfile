FROM ubuntu:16.04
MAINTAINER Jason Zhang <jason.zhang@internetrix.com.au>
ARG DEBIAN_FRONTEND=noninteractive

### SET UP

RUN apt -qq update

# Supporting tools
RUN apt -qqy install sudo wget telnet nano vim curl make git bzip2 zip unzip gettext-base locales cifs-utils software-properties-common

RUN echo "LANG=en_US.UTF-8\n" > /etc/default/locale && \
	echo "en_US.UTF-8 UTF-8\n" > /etc/locale.gen && \
	locale-gen
	
ENV ENV LANG en_US.UTF-8

# APACHE 
RUN apt -qqy install apache2 

## Multi PHP Version Support
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt -qq update

RUN apt -qqy upgrade
	
# PHP 5.6
RUN apt -qqy install php5.6 php5.6-cli php5.6-fpm php5.6-mysql php5.6-curl php5.6-soap php5.6-common php5.6-gd php5.6-mcrypt php5.6-tidy php5.6-mbstring

RUN echo "date.timezone = Australia/Sydney" > /etc/php/5.6/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/5.6/fpm/conf.d/timezone.ini
	
# PHP 7.0
RUN apt -qqy install php7.0 php7.0-cli php7.0-fpm php7.0-mysql php7.0-curl php7.0-soap php7.0-common php7.0-gd php7.0-mcrypt php7.0-tidy php7.0-mbstring
	
RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.0/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.0/fpm/conf.d/timezone.ini
	
# Apache & PHP Configuration
RUN echo "webdev is ok" > /var/www/html/index.html && \
	a2dismod php7.0 php5.6
	a2enmod rewrite proxy proxy_fcgi proxy_http expires ssl vhost_alias headers
	
ADD apache-wildcard-php70-vhost /etc/apache2/sites-available/000-default.conf
ADD apache-wildcard-php56-vhost /etc/apache2/sites-available/000-wildcard-php56-vhost.conf
	
# Composer
RUN wget https://getcomposer.org/composer.phar && \
	chmod +x composer.phar && \
	mv composer.phar /usr/local/bin/composer && \
	
# NodeJS and common global NPM modules
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
	apt-get install -qqy nodejs && \
	npm install -g grunt-cli gulp bower

VOLUME /var/www

# Run apache in foreground mode, because Docker needs a foreground
ADD apache-foreground /usr/local/bin/apache-foreground

WORKDIR /var/www

EXPOSE 80 443

CMD ["/usr/local/bin/apache-foreground"]