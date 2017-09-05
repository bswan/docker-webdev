FROM internetrix/webdev:lap
MAINTAINER Jason Zhang <jason.zhang@internetrix.com.au>
ARG DEBIAN_FRONTEND=noninteractive

### Apache & PHP Configuration
RUN a2enmod rewrite proxy proxy_fcgi proxy_http expires ssl vhost_alias headers

# Setup Apache permission for shared folder /media/www/
ADD apache-shared-workplace-folder.conf /etc/apache2/conf-available/apache-shared-workplace-folder.conf
RUN a2enconf apache-shared-workplace-folder.conf

# Setup Apache wildcard vhost for multi PHP versions
ADD apache-wildcard-default-vhost.conf /etc/apache2/sites-available/000-default.conf
ADD apache-wildcard-php70-vhost.conf /etc/apache2/sites-available/001-wildcard-php70-vhost.conf
ADD apache-wildcard-php56-vhost.conf /etc/apache2/sites-available/002-wildcard-php56-vhost.conf

RUN a2ensite 001-wildcard-php70-vhost.conf 002-wildcard-php56-vhost.conf

# Forward apache logs to docker console.
RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

# Run apache in foreground
ADD apache-foreground.sh /usr/local/bin/

EXPOSE 80 443

CMD ["apache-foreground.sh"]