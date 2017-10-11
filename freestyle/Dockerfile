FROM perl:5.26
MAINTAINER Jason Zhang <jason.zhang@internetrix.com.au>
ARG DEBIAN_FRONTEND=noninteractive

### SET UP
RUN apt-get -qq update

# Supporting tools
RUN apt-get -qqy install wget telnet vim curl git bzip2 zip unzip

# Apache 2 and mod-perl
RUN apt-get -qqy install apache2

# Install / Setup Perl modules checker
RUN cpan Module::Extract::Use Module::ExtractUse && \
	curl https://raw.githubusercontent.com/briandfoy/module-extract-use/master/examples/extract_modules -o /usr/local/bin/extract_perl_modules && \
	chmod +x /usr/local/bin/extract_perl_modules




