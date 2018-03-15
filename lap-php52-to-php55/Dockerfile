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

## Add Old PHP Version Packages
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:sergey-dryabzhinsky/packages
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:sergey-dryabzhinsky/php53
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:sergey-dryabzhinsky/php54
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:sergey-dryabzhinsky/php55

RUN apt-get -qq update

RUN apt-get -qqy upgrade

# PHP 5.3
RUN apt-get -qqy install php53-cli php53-fpm php53-common php53-mod-curl php53-mod-dom php53-mod-exif php53-mod-fileinfo php53-mod-gd php53-mod-mbstring php53-mod-gettext php53-mod-mysql php53-mod-ftp php53-mod-simplexml php53-mod-xmlreader php53-mod-tokenizer php53-mod-intl php53-mod-soap

RUN echo "date.timezone = Australia/Sydney" > /etc/php53/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php53/fpm/conf.d/timezone.ini
	
# PHP 5.4
RUN apt-get -qqy install php54-cli php54-fpm php54-common php54-mod-curl php54-mod-dom php54-mod-exif php54-mod-fileinfo php54-mod-gd php54-mod-mbstring php54-mod-gettext php54-mod-mysql php54-mod-ftp php54-mod-simplexml php54-mod-xmlreader php54-mod-tokenizer php54-mod-intl php54-mod-soap

RUN echo "date.timezone = Australia/Sydney" > /etc/php54/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php54/fpm/conf.d/timezone.ini

# PHP 5.5
RUN apt-get -qqy install php55-cli php55-fpm php55-common php55-mod-curl php55-mod-dom php55-mod-exif php55-mod-fileinfo php55-mod-gd php55-mod-mbstring php55-mod-gettext php55-mod-mysql php55-mod-ftp php55-mod-simplexml php55-mod-xmlreader php55-mod-tokenizer php55-mod-intl php55-mod-soap

RUN echo "date.timezone = Australia/Sydney" > /etc/php55/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php55/fpm/conf.d/timezone.ini

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