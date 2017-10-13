FROM perl:5.26
MAINTAINER Jason Zhang <jason.zhang@internetrix.com.au>
ARG DEBIAN_FRONTEND=noninteractive

### SET UP
RUN apt-get -qq update

# Supporting tools
RUN apt-get -qqy install wget telnet vim nano curl git bzip2 zip unzip

# Install Apache2 and mod_perl2
RUN apt-get -qqy install apache2 libapache2-mod-perl2

# Enable cgi for mod-perl2
RUN a2enmod cgi

# Install / Setup Perl modules checker
RUN apt-get -qqy install libmodule-extract-use-perl && \
	curl https://raw.githubusercontent.com/briandfoy/module-extract-use/master/examples/extract_modules -o /usr/local/bin/extract_perl_modules && \
	chmod +x /usr/local/bin/extract_perl_modules

# Install perl modules required by freestyle /www/lib
RUN apt-get -qqy install libyaml-perl && \
	libarchive-zip-perl && \
	libmethod-autoload-perl && \
	libcgi-pm-perl && \
	libcgi-session-perl && \
	libcache-memcached-fast-perl && \
	libcaptcha-recaptcha-perl && \
	libcrypt-openssl-rsa-perl && \
	libdate-calc-perl && \
	libdatetime-perl && \
	libdatetime-format-http-perl && \
	libdatetime-format-mail-perl && \
	libdatetime-format-mysql-perl && \
	libemail-address-perl && \
	libemail-mime-perl && \
	libemail-sender-perl && \
	libfile-slurp-perl && \
	libfile-tail-perl && \
	libfile-type-perl && \
	libfile-chdir-perl && \
	libfont-ttf-perl && \
	libgd-perl && \
	libgd-graph-perl && \
	libgeo-ip-perl && \
	libgimp-compat-perl && \
	libgtk2-perl && \
	libhtml-mason-perl && \
	libhtml-parsebrowser-perl && \
	libhttp-dav-perl && \
	libjson-perl && \
	liblingua-en-numbers-ordinate-perl && \
	liblist-moreutils-perl && \
	liblocale-subcountry-perl && \
	liblog-log4perl-perl && \
	libmail-dkim-perl && \
	libmail-imapclient-perl && \
	libmodule-find-perl && \
	libmoose-perl && \
	libmoosex-singleton-perl && \
	libnet-ldap-perl && \
	libnet-oauth-perl && \
	libnet-twitter-perl && \
	libpdf-reuse-perl && \
	libsort-versions-perl && \
	libspreadsheet-writeexcel-perl && \
	libstatistics-lite-perl && \
	libtemplate-perl && \
	libtext-aspell-perl && \
	libtext-context-perl && \
	libtext-reform-perl && \
	libtext-xsv-perl && \
	libtext-csv-perl && \
	libxml-atom-perl && \
	libxml-quote-perl && \
	libxml-smart-perl && \
	libxml-twig-perl && \


