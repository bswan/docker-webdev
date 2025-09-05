FROM internetrix/webdev:legacy-lap
LABEL "org.opencontainers.image.authors"="Vladyslav Aksonov <vladyslav.aksonov@gmail.com>"
LABEL "org.opencontainers.image.source"="https://github.com/bswan2/docker-webdev/legacy/leegacy-lap-wildcard"
LABEL "org.opencontainers.image.description"="A Docker image for PHP web development with Apache wildcard domains, multiple PHP versions (including EoL), phpMyAdmin, Composer, NodeJS, XDebug and more."

ARG DEBIAN_FRONTEND=noninteractive

### PHP Configuration
RUN apt-get -y update
RUN apt-get -y install php-xdebug

# Add custom PHP configs
ADD config/php/webdev_common_php_config.ini /etc/php/webdev_common_php_config.ini
RUN cat /etc/php/webdev_common_php_config.ini | tee -a {{PHP_INI_FILES}}

### Apache Configuration
RUN a2enmod rewrite proxy proxy_fcgi proxy_http expires ssl vhost_alias headers env

# Setup Apache config for webdev server
ADD config/apache/conf/webdev.conf /etc/apache2/conf-available/webdev.conf
RUN a2enconf webdev.conf

# Setup /phpinfo alias
RUN mkdir /var/www/php/ && \
	chmod +x /var/www/php/ && \
	echo '<?php phpinfo() ?>' > /var/www/php/phpinfo.php && \
	chmod +x /var/www/php/phpinfo.php && \
	echo 'Alias /phpinfo /var/www/php/phpinfo.php' > /etc/apache2/conf-available/phpinfo.conf && \
 	a2enconf phpinfo.conf

# Setup Apache wildcard vhosts
{{APACHE_VHOSTS}}

# Default wildcard has lowest priority
ADD config/apache/sites/apache-wildcard-default-vhost.conf /etc/apache2/sites-available/111-wildcard-default.conf

RUN a2ensite \ {{APACHE_SITES}}
    111-wildcard-default.conf

# Setup Webgrind - web based front-end xdebug profile information presentation tool
ADD config/apache/conf/apache-phpwebgrind.conf /etc/apache2/conf-available/phpwebgrind.conf
RUN mkdir /var/www/php/xdebug.profiler && \
    chmod 777 /var/www/php/xdebug.profiler && \
	cd /var/www/php && \
	git clone https://github.com/jokkedk/webgrind.git webgrind && \
	a2enconf phpwebgrind.conf

# Forward apache logs to docker console.
RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

# Run apache in foreground
ADD apache-foreground.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/apache-foreground.sh"]

# Add a template .bashrc so password is asked for SSH only once in session
ADD bashrc-example /root/.bashrc

EXPOSE 80 443

ENV WEBDEV_PHPMYADMIN_DB_HOST=mariadb
ENV WEBDEV_PHPMYADMIN_DB_USER=root
ENV WEBDEV_PHPMYADMIN_DB_PW=root123
ENV WEBDEV_REMOTE_HOST_IP=192.168.99.1
ENV WEBDEV_CIFS_HOST_FOLDER=//192.168.99.1/www
ENV WEBDEV_CIFS_SMB_VERSION=3.0
ENV WEBDEV_CIFS_USER=container
ENV WEBDEV_CIFS_PW=container123
ENV WEBDEV_POSTFIX_RELAYHOST=[mailhog]:1025
ENV COMPOSER_DEFAULT_VERSION=2
{{ENVS}}

CMD ["/usr/local/bin/apache-foreground.sh"]
