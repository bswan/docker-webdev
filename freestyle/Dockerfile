FROM perl:5.26
MAINTAINER Jason Zhang <jason.zhang@internetrix.com.au>
ARG DEBIAN_FRONTEND=noninteractive

### SET UP
RUN apt-get -qq update

# Supporting tools
RUN apt-get -qqy install wget telnet vim curl git bzip2 zip unzip apache2

# Link /usr/bin/perl (system default one) to /usr/local/bin/perl (container installed one which is perl:5.26)
RUN rm /usr/bin/perl && ln -s /usr/local/bin/perl /usr/bin/perl

# Install / Setup Perl modules checker
RUN cpan Module::Extract::Use Module::ExtractUse && \
	curl https://raw.githubusercontent.com/briandfoy/module-extract-use/master/examples/extract_modules -o /usr/local/bin/extract_perl_modules && \
	chmod +x /usr/local/bin/extract_perl_modules

# Install perl modules required by freestyle /www/lib
RUN cpan APR::Table
RUN cpan Apache2::Connection
RUN cpan Apache2::Const
RUN cpan Apache2::RequestIO
RUN cpan Apache2::RequestRec
RUN cpan Archive::Zip
RUN cpan AutoLoader
RUN cpan CGI
RUN cpan CGI::Cookie
RUN cpan CGI::Session
RUN cpan CGI::Upload
RUN cpan Cache::Memcached::Fast
RUN cpan Captcha::reCAPTCHA
RUN cpan Carp
RUN cpan Compress::Zlib
RUN cpan Crypt::OpenSSL::RSA
RUN cpan Cwd
RUN cpan DBI
RUN cpan Data::Dumper
RUN cpan Date::Calendar
RUN cpan Date::Calendar::Profiles
RUN cpan Date::ICal
RUN cpan DateTime
RUN cpan DateTime::Format::Atom
RUN cpan DateTime::Format::HTTP
RUN cpan DateTime::Format::Mail
RUN cpan DateTime::Format::MySQL
RUN cpan DateTime::TimeZone
RUN cpan Digest::MD5
RUN cpan DynaLoader
RUN cpan Email::Address
RUN cpan Email::MIME
RUN cpan Email::Sender::Simple
RUN cpan Encode
RUN cpan Exporter
RUN cpan Fcntl
RUN cpan File::Basename
RUN cpan File::Copy
RUN cpan File::Find
RUN cpan File::Path
RUN cpan File::Slurp
RUN cpan File::Tail
RUN cpan File::Type
RUN cpan File::chdir
RUN cpan FileHandle
RUN cpan Filesys::DiskUsage
RUN cpan Font::TTF::Font
RUN cpan GD
RUN cpan GD::Graph::mixed
RUN cpan Geo::IP
RUN cpan Gimp::Compat
RUN cpan Gtk2
RUN cpan HTML::Entities
RUN cpan HTML::FormatText
RUN cpan HTML::Mason
RUN cpan HTML::ParseBrowser
RUN cpan HTML::TreeBuilder
RUN cpan HTTP::Cookies
RUN cpan HTTP::DAV
RUN cpan HTTP::Request
RUN cpan HTTP::Request::Common
RUN cpan HTTP::Response
RUN cpan HTTP::Status
RUN cpan IO::File
RUN cpan JSON
RUN cpan LWP::Simple
RUN cpan LWP::UserAgent
RUN cpan Lingua::EN::Numbers::Ordinate
RUN cpan List::MoreUtils
RUN cpan List::Util
RUN cpan Locale::Country
RUN cpan Locale::SubCountry
RUN cpan Log::Log4perl
RUN cpan MIME::Base64
RUN cpan MIME::Lite
RUN cpan MIME::Parser
RUN cpan Mail::DKIM::Signer
RUN cpan Mail::IMAPClient
RUN cpan Module::Find
RUN cpan MongoDB
RUN cpan Moose
RUN cpan Moose::Util::TypeConstraints
RUN cpan MooseX::Singleton
RUN cpan Net::Google::Calendar
RUN cpan Net::Google::Calendar::Entry
RUN cpan Net::Google::Calendar::Person
RUN cpan Net::Google::Data::Licensing::Domain
RUN cpan Net::Google::Data::Provisioning
RUN cpan Net::Google::Data::Provisioning::User
RUN cpan Net::Google::FederatedLogin
RUN cpan Net::LDAP
RUN cpan Net::OAuth
RUN cpan Net::Twitter
RUN cpan OpenOffice::OODoc
RUN cpan PDF::Reuse
RUN cpan PDF::Reuse::Util
RUN cpan POSIS
RUN cpan POSIX
RUN cpan Scalar::Util
RUN cpan SelfLoader
RUN cpan Sort::Versions
RUN cpan Spreadsheet::WriteExcel
RUN cpan Spreadsheet::WriteExcel::Big
RUN cpan Spreadsheet::WriteExcel::Utility
RUN cpan Statistics::Lite
RUN cpan Storable
RUN cpan Sys::Hostname
RUN cpan Telephony::CountryDialingCodes
RUN cpan Template
RUN cpan Template::Stash
RUN cpan Text::Aspell
RUN cpan Text::Context
RUN cpan Text::PDF::Array
RUN cpan Text::PDF::Bool
RUN cpan Text::PDF::Dict
RUN cpan Text::PDF::Filter
RUN cpan Text::PDF::Name
RUN cpan Text::PDF::Null
RUN cpan Text::PDF::Number
RUN cpan Text::PDF::Objind
RUN cpan Text::PDF::Page
RUN cpan Text::PDF::Pages
RUN cpan Text::PDF::String
RUN cpan Text::PDF::TTFont
RUN cpan Text::PDF::TTFont0
RUN cpan Text::PDF::Utils
RUN cpan Text::Reform
RUN cpan Text::xSV
RUN cpan Tie::SecureHash
RUN cpan Time::HiRes
RUN cpan Time::Local
RUN cpan UNIVERSAL
RUN cpan URI::Escape
RUN cpan Versionify::Dispatch
RUN cpan WWW::Shorten::Bitly
RUN cpan XML::Atom::Entry
RUN cpan XML::Atom::Feed
RUN cpan XML::DOM
RUN cpan XML::Parser
RUN cpan XML::Quote
RUN cpan XML::Smart
RUN cpan XML::Twig
RUN cpan XSLoader
