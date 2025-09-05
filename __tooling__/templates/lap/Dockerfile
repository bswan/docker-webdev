# Based on Latest Ubuntu LTS
FROM ubuntu:{{UBUNTU_LTS_VERSION}}
LABEL "org.opencontainers.image.authors"="Vladyslav Aksonov <vladyslav.aksonov@gmail.com>"
LABEL "org.opencontainers.image.source"="https://github.com/bswan2/docker-webdev/lap"
LABEL "org.opencontainers.image.description"="A Docker image for PHP web development with Apache, multiple PHP versions, phpMyAdmin, Composer, NodeJS, XDebug and more."

ARG DEBIAN_FRONTEND=noninteractive
ARG PMA_VERSION={{PMA_VERSION}}
ARG NODE_VERSION="current"

### Change to default mirror to AU mirror - https://wiki.ubuntu.com/AustralianTeam/LocalAptMirrors#Australian_Mirrors
RUN cp /etc/apt/sources.list /etc/apt/sources.list.origin && \
	sed -i -e 's/http:\/\/archive./http:\/\/au.archive./g' /etc/apt/sources.list && \
	sed -i -e 's/http:\/\/releases./http:\/\/au.releases./g' /etc/apt/sources.list

### SET UP
RUN apt-get -qq update

# Supporting tools
RUN apt-get -qqy install sqlite3 sudo wget telnet nano vim curl make git bzip2 zip unzip gettext-base locales cifs-utils software-properties-common dnsutils iputils-ping net-tools mailutils mariadb-client mc

RUN echo "LANG=en_US.UTF-8\n" > /etc/default/locale && \
	echo "en_US.UTF-8 UTF-8\n" > /etc/locale.gen && \
	locale-gen

ENV LANG=en_US.UTF-8

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt -qqy install ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

RUN apt-get -qq update

RUN apt-get -qqy upgrade

# APACHE
RUN apt-get -qqy install apache2

{{PHP_INSTALL_CMDS}}

# Apache & PHP Configuration
RUN echo "webdev is ok" > /var/www/html/index.html

# Setup phpmyadmin
ADD apache-phpmyadmin.conf /etc/apache2/conf-available/phpmyadmin.conf

RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz && \
	tar xzf phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz -C /opt && \
	rm phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz && \
	mv /opt/phpMyAdmin-${PMA_VERSION}-all-languages /opt/phpmyadmin && \
	a2enconf phpmyadmin.conf
	
# Add default phpmyadmin config
ADD phpmyadmin.config.inc.php /opt/phpmyadmin/config.inc.php
RUN mkdir /opt/phpmyadmin/tmp

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
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
	apt-get install -qqy nodejs

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
apt update && apt install yarn

# Install Node Version Manager (nvm)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

#SSPAK
RUN curl -sS https://silverstripe.github.io/sspak/install | php -- /usr/local/bin

