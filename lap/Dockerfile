FROM ubuntu:22.04
MAINTAINER Jonathon Su <jonathon.su@internetrix.com.au>
ARG DEBIAN_FRONTEND=noninteractive

### Change to default mirror to AU mirror - https://wiki.ubuntu.com/AustralianTeam/LocalAptMirrors#Australian_Mirrors
RUN cp /etc/apt/sources.list /etc/apt/sources.list.origin && \
	sed -i -e 's/http:\/\/archive./http:\/\/au.archive./g' /etc/apt/sources.list && \
	sed -i -e 's/http:\/\/releases./http:\/\/au.releases./g' /etc/apt/sources.list

### SET UP
RUN apt-get -qq update

# Supporting tools
RUN apt-get -qqy install sqlite sudo wget telnet nano vim curl make git bzip2 zip unzip gettext-base locales cifs-utils software-properties-common dnsutils iputils-ping net-tools mailutils mariadb-client mc

RUN echo "LANG=en_US.UTF-8\n" > /etc/default/locale && \
	echo "en_US.UTF-8 UTF-8\n" > /etc/locale.gen && \
	locale-gen

ENV ENV LANG en_US.UTF-8

# APACHE
RUN apt-get -qqy install apache2

## Stable PHP Versions - 5.6 | 7.0 | 7.1 | 7.2
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get -qq update

RUN apt-get -qqy upgrade

# PHP 8.2
RUN apt-get -qqy install php8.2 php8.2-cli php8.2-xdebug php8.2-fpm php8.2-mysql php8.2-curl php8.2-soap php8.2-common php8.2-gd php8.2-tidy php8.2-mbstring php8.2-xml php8.2-intl php8.2-memcache php8.2-yaml php8.2-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/8.2/cli/conf.d/timezone.ini && \
    echo "date.timezone = Australia/Sydney" > /etc/php/8.2/fpm/conf.d/timezone.ini

# PHP 8.1
RUN apt-get -qqy install php8.1 php8.1-cli php8.1-xdebug php8.1-fpm php8.1-mysql php8.1-curl php8.1-soap php8.1-common php8.1-gd php8.1-tidy php8.1-mbstring php8.1-xml php8.1-intl php8.1-memcache php8.1-yaml php8.1-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/8.1/cli/conf.d/timezone.ini && \
    echo "date.timezone = Australia/Sydney" > /etc/php/8.1/fpm/conf.d/timezone.ini

# PHP 8.0
RUN apt-get -qqy install php8.0 php8.0-cli php8.0-xdebug php8.0-fpm php8.0-mysql php8.0-curl php8.0-soap php8.0-common php8.0-gd php8.0-tidy php8.0-mbstring php8.0-xml php8.0-intl php8.0-memcache php8.0-yaml php8.0-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/8.0/cli/conf.d/timezone.ini && \
    echo "date.timezone = Australia/Sydney" > /etc/php/8.0/fpm/conf.d/timezone.ini

# PHP 7.4
RUN apt-get -qqy install php7.4 php7.4-cli php7.4-xdebug php7.4-fpm php7.4-mysql php7.4-curl php7.4-soap php7.4-common php7.4-gd php7.4-tidy php7.4-mbstring php7.4-xml php7.4-intl php7.4-memcache php7.4-yaml php7.4-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.4/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.4/fpm/conf.d/timezone.ini

# PHP 7.3
RUN apt-get -qqy install php7.3 php7.3-cli php7.3-xdebug php7.3-fpm php7.3-mysql php7.3-curl php7.3-soap php7.3-common php7.3-gd php7.3-tidy php7.3-mbstring php7.3-xml php7.3-intl php7.3-memcache php7.3-yaml php7.3-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.3/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.3/fpm/conf.d/timezone.ini

# PHP 7.2
RUN apt-get -qqy install php7.2 php7.2-cli php7.2-xdebug php7.2-fpm php7.2-mysql php7.2-curl php7.2-soap php7.2-common php7.2-gd php7.2-tidy php7.2-mbstring php7.2-xml php7.2-intl php7.2-memcache php7.2-yaml php7.2-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.2/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.2/fpm/conf.d/timezone.ini

# PHP 7.1
RUN apt-get -qqy install php7.1 php7.1-cli php7.1-xdebug php7.1-fpm php7.1-mysql php7.1-curl php7.1-soap php7.1-common php7.1-gd php7.1-mcrypt php7.1-tidy php7.1-mbstring php7.1-xml php7.1-intl php7.1-memcache php7.1-yaml php7.1-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.1/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.1/fpm/conf.d/timezone.ini

# PHP 7.0
RUN apt-get -qqy install php7.0 php7.0-cli php7.0-xdebug php7.0-fpm php7.0-mysql php7.0-curl php7.0-soap php7.0-common php7.0-gd php7.0-mcrypt php7.0-tidy php7.0-mbstring php7.0-xml php7.0-intl php7.0-memcache php7.0-yaml php7.0-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/7.0/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/7.0/fpm/conf.d/timezone.ini

# PHP 5.6
RUN apt-get -qqy install php5.6 php5.6-cli php5.6-xdebug php5.6-fpm php5.6-mysql php5.6-common php5.6-curl php5.6-soap php5.6-gd php5.6-mcrypt php5.6-tidy php5.6-mbstring php5.6-xml php5.6-intl php5.6-memcache php5.6-yaml php5.6-zip

RUN echo "date.timezone = Australia/Sydney" > /etc/php/5.6/cli/conf.d/timezone.ini && \
	echo "date.timezone = Australia/Sydney" > /etc/php/5.6/fpm/conf.d/timezone.ini


# Apache & PHP Configuration
RUN echo "webdev is ok" > /var/www/html/index.html

# Setup phpmyadmin
ADD apache-phpmyadmin.conf /etc/apache2/conf-available/phpmyadmin.conf
ADD apache-phpmyadmin_legacy.conf /etc/apache2/conf-available/phpmyadmin_legacy.conf

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.tar.gz && \
	tar xzf phpMyAdmin-5.2.0-all-languages.tar.gz -C /opt && \
	rm phpMyAdmin-5.2.0-all-languages.tar.gz && \
	mv /opt/phpMyAdmin-5.2.0-all-languages /opt/phpmyadmin && \
	a2enconf phpmyadmin.conf

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.10/phpMyAdmin-4.9.10-all-languages.tar.gz && \
	tar xzf phpMyAdmin-4.9.10-all-languages.tar.gz -C /opt && \
	rm phpMyAdmin-4.9.10-all-languages.tar.gz && \
	mv /opt/phpMyAdmin-4.9.10-all-languages /opt/phpmyadmin_legacy
	
# Add default phpmyadmin config
ADD phpmyadmin.config.inc.php /opt/phpmyadmin/config.inc.php
RUN mkdir /opt/phpmyadmin/tmp

# Add default phpmyadmin config
ADD phpmyadmin.config.inc.php /opt/phpmyadmin_legacy/config.inc.php
RUN mkdir /opt/phpmyadmin_legacy/tmp

# Composer
# Composer 2
RUN wget https://getcomposer.org/composer.phar && \
	chmod +x composer.phar && \
	mv composer.phar /usr/local/bin/composer2
#Composer 1 
RUN	cp /usr/local/bin/composer2 /usr/local/bin/composer1 && \
	composer1 self-update --1
#Alternatives
RUN update-alternatives --install /usr/local/bin/composer composer /usr/local/bin/composer2 2
RUN update-alternatives --install /usr/local/bin/composer composer /usr/local/bin/composer1 1

# NodeJS and common global NPM modules
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
	apt-get install -qqy nodejs

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
apt update && apt install yarn

# Blackfire Debian repo setup
RUN wget -q -O - https://packagecloud.io/gpg.key | apt-key add - && \
    echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list

## Blackfire (PHP profiling) - install agent & PHP Probe
RUN wget -q -O - https://packages.blackfire.io/gpg.key | sudo apt-key add - && \
echo "deb http://packages.blackfire.io/debian any main" | sudo tee /etc/apt/sources.list.d/blackfire.list && \
apt update && apt install blackfire-agent blackfire-php

#SSPAK
RUN curl -sS https://silverstripe.github.io/sspak/install | php -- /usr/local/bin

