FROM internetrix/webdev:lap
MAINTAINER Jason Zhang <jason.zhang@internetrix.com.au>
ARG DEBIAN_FRONTEND=noninteractive

# Apache & PHP Configuration
RUN a2enmod rewrite proxy proxy_fcgi proxy_http expires ssl vhost_alias headers

ADD apache-shared-workplace-folder.conf /etc/apache2/conf-available/apache-shared-workplace-folder.conf

RUN a2enconf apache-shared-workplace-folder.conf

ADD apache-wildcard-php70-vhost.conf /etc/apache2/sites-available/001-wildcard-php70-vhost.conf
ADD apache-wildcard-php56-vhost.conf /etc/apache2/sites-available/002-wildcard-php56-vhost.conf

RUN a2ensite 001-wildcard-php70-vhost.conf 002-wildcard-php56-vhost.conf

# Run apache in foreground
ADD apache-foreground /usr/local/bin/

EXPOSE 80 443

CMD ["apache-foreground"]