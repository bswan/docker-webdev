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

# APACHE 
RUN apt -qqy install apache2 

EXPOSE 80

EXPOSE 443

# MariaDB Server

RUN \
  groupadd mysql && \
  useradd -g mysql mysql && \
  apt install -y mariadb-server && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/lib/mysql && \
  mkdir --mode=0777 /var/lib/mysql /var/run/mysqld && \
  chown mysql:mysql /var/lib/mysql && \
  sed -r -i -e 's/^bind-address\s+=\s+127\.0\.0\.1$/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
#  sed -r -i -e 's/^user\s+=\s+mysql$/#user = mysql/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
#  sed -i -r -e 's/^#general_log_file\s+=.*/general_log_file=\/var\/log\/mysql\/mysql.log/g' /etc/mysql/mariadb.conf.d/50-server.cnf && \
#  sed -i -r -e '/^query_cache/d' /etc/mysql/mariadb.conf.d/50-server.cnf && \
  printf '[mysqld]\nskip-name-resolve\n' > /etc/mysql/conf.d/skip-name-resolve.cnf && \
  printf '[mysqld]\ninnodb_file_per_table\ninnodb_file_format = Barracuda\n' > /etc/mysql/conf.d/innodb-barracuda.cnf && \
  chmod 0777 -R /var/lib/mysql /var/log/mysql && \
  chmod 0775 -R /etc/mysql && \

EXPOSE 3306
	
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
	
ADD apache-foreground /usr/local/bin/apache-foreground

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
WORKDIR /var/www
CMD ["/usr/local/bin/apache-foreground"]

ENV MYSQL_ROOT_PASSWORD=root123 \
    DISABLE_PHPMYADMIN=0 \
    PMA_ARBITRARY=0 \
    PMA_HOST=localhost \
    MYSQL_GENERAL_LOG=0 \
    MYSQL_QUERY_CACHE_TYPE=1 \
    MYSQL_QUERY_CACHE_SIZE=16M \
    MYSQL_QUERY_CACHE_LIMIT=1M \
    ENV LANG en_US.UTF-8
