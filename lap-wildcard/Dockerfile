FROM internetrix/webdev:lap
MAINTAINER Jason Zhang <jason.zhang@internetrix.com.au>
ARG DEBIAN_FRONTEND=noninteractive

### PHP Configuration
# Install xdebug for PHP 5.6+
RUN apt-get install php-xdebug

### Apache Configuration
RUN a2enmod rewrite proxy proxy_fcgi proxy_http expires ssl vhost_alias headers

# Setup Apache permission for shared folder /media/www/
ADD apache-shared-workplace-folder.conf /etc/apache2/conf-available/shared-workplace-folder.conf
RUN a2enconf shared-workplace-folder.conf

# Setup /phpinfo alias
RUN mkdir /var/www/php/ && \
	chmod +x /var/www/php/ && \
	echo '<?php phpinfo() ?>' > /var/www/php/phpinfo.php && \
	chmod +x /var/www/php/phpinfo.php && \
	echo 'Alias /phpinfo /var/www/php/phpinfo.php' > /etc/apache2/conf-available/phpinfo.conf && \
 	a2enconf phpinfo.conf

# Setup Apache wildcard vhost for multi PHP versions
ADD apache-wildcard-php70-vhost.conf /etc/apache2/sites-available/001-wildcard-php70-vhost.conf
ADD apache-wildcard-php56-vhost.conf /etc/apache2/sites-available/002-wildcard-php56-vhost.conf
# Default wildcard has lowest priority
ADD apache-wildcard-default-vhost.conf /etc/apache2/sites-available/003-wildcard-default.conf

RUN a2ensite 001-wildcard-php70-vhost.conf 002-wildcard-php56-vhost.conf 003-wildcard-default.conf

# Forward apache logs to docker console.
RUN ln -sf /dev/stderr /var/log/apache2/error.log

# Run apache in foreground
ADD apache-foreground.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/apache-foreground.sh"]

EXPOSE 80 443

#ENV WEBDEV_DB_HOST_IP			192.168.99.100
ENV WEBDEV_PHPMYADMIN_DB_HOST 	mariadb
ENV WEBDEV_PHPMYADMIN_DB_USER 	root
ENV WEBDEV_PHPMYADMIN_DB_PW 	root123
ENV WEBDEV_ENABLE_PHP_56_FPM 	1
ENV WEBDEV_ENABLE_PHP_70_FPM 	1
ENV WEBDEV_CIFS_HOST_FOLDER 	//192.168.99.1/www
ENV WEBDEV_CIFS_USER 			container
ENV WEBDEV_CIFS_PW 				container123

CMD ["/usr/local/bin/apache-foreground.sh"]