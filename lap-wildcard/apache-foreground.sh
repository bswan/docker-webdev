#!/bin/bash

# CIFS config for Windows
# Mount CIFS folder if not exists (Mac might use bind mount on /media/www)

	echo '==Checking if folder needs to be mounted';

if [ ! -d /media/www ] || [ "$(ls -A /media/www 2> /dev/null)" == "" ]; then
	echo '==Folder needs to be mounted because media www folder is empty';

	# On some computers mount with no vers flag will break while on some computers if there is a vers flag, it will also break
	# Give user choice to define whether they want to use the ver flag
    if [ "WEBDEV_CIFS_SMB_VERSION" = 2.0 ]; then
	    echo "$WEBDEV_CIFS_HOST_FOLDER  /media/www  cifs  vers=$WEBDEV_CIFS_SMB_VERSION,uid=www-data,gid=www-data,file_mode=0777,dir_mode=0777,username=$WEBDEV_CIFS_USER,password=$WEBDEV_CIFS_PW,iocharset=utf8,sec=ntlm  0  0" > /etc/fstab
    else
    	echo "$WEBDEV_CIFS_HOST_FOLDER  /media/www  cifs  uid=www-data,gid=www-data,file_mode=0777,dir_mode=0777,username=$WEBDEV_CIFS_USER,password=$WEBDEV_CIFS_PW,iocharset=utf8  0  0" > /etc/fstab
    fi

	echo '==Going to mount Windows shared folder via network';
	mkdir /media/www
	mount -a
	if [ "$(ls -A /media/www 2> /dev/null)" != "" ]; then
		echo 'CIFS folder is successfully mounted'
	fi
fi

# If /tmpwww/ tmpfs folder exists, make sure it's open for everyone.
if [ -d /tmpwww/ ]; then
	chmod -R 777 /tmpwww/
fi

# Setup custom 'db' host IP
if [ -z ${WEBDEV_DB_HOST_IP+x} ]; then
	echo "No custom WEBDEV_DB_HOST_IP"
else
	#custom value from WEBDEV_DB_HOST_IP
	echo "$WEBDEV_DB_HOST_IP	db" >> /etc/hosts
fi

# Setup phpmyadmin db config
## Remove old webdev config
sed -i '/##START-webdev-config/,/##END-webdev-config/d' /opt/phpmyadmin/config.inc.php
echo "##START-webdev-config" >> /opt/phpmyadmin/config.inc.php
echo "# Override default config" >> /opt/phpmyadmin/config.inc.php
echo "\$cfg['Servers'][1]['host'] = '$WEBDEV_PHPMYADMIN_DB_HOST';" >> /opt/phpmyadmin/config.inc.php
echo "\$cfg['Servers'][1]['user'] = '$WEBDEV_PHPMYADMIN_DB_USER';" >> /opt/phpmyadmin/config.inc.php
echo "\$cfg['Servers'][1]['password'] = '$WEBDEV_PHPMYADMIN_DB_PW';" >> /opt/phpmyadmin/config.inc.php
echo "##END-webdev-config" >> /opt/phpmyadmin/config.inc.php

## setup phpmyadmin config to use correct php.fpm handler, depending on php version set
# Remove old phpmyadmin handler config
sed -i '/#phpmyadminhandlerstart/,/#phpmyadminhandlerend/{//!d}' /etc/apache2/conf-enabled/phpmyadmin.conf
# Set new phpmyadmin handler config: /etc/apache2/conf-enabled/phpmyadmin.conf
if [ "$WEBDEV_ENABLE_PHP_74_FPM" = 1 ]; then
	echo "==============Setting phpMyAdmin handler to 7.4 ..."
	sed -i '/#phpmyadminhandlerstart/a SetHandler "proxy:unix:/run/php/php7.4-fpm.sock|fcgi://localhost"' /etc/apache2/conf-enabled/phpmyadmin.conf
elif [ "$WEBDEV_ENABLE_PHP_73_FPM" = 1 ]; then
	echo "==============Setting phpMyAdmin handler to 7.3 ..."
	sed -i '/#phpmyadminhandlerstart/a SetHandler "proxy:unix:/run/php/php7.3-fpm.sock|fcgi://localhost"' /etc/apache2/conf-enabled/phpmyadmin.conf
elif [ "$WEBDEV_ENABLE_PHP_72_FPM" = 1 ]; then
	echo "==============Setting phpMyAdmin socket to 7.2 ..."
	sed -i '/#phpmyadminhandlerstart/a SetHandler "proxy:unix:/run/php/php7.2-fpm.sock|fcgi://localhost"' /etc/apache2/conf-enabled/phpmyadmin.conf
elif [ "$WEBDEV_ENABLE_PHP_71_FPM" = 1 ]; then
	echo "==============Setting phpMyAdmin socket to 7.1 ..."
	sed -i '/#phpmyadminhandlerstart/a SetHandler "proxy:unix:/run/php/php7.1-fpm.sock|fcgi://localhost"' /etc/apache2/conf-enabled/phpmyadmin.conf
elif [ "$WEBDEV_ENABLE_PHP_70_FPM" = 1 ]; then
	echo "==============Setting phpMyAdmin socket to 7.0 ..."
	sed -i '/#phpmyadminhandlerstart/a SetHandler "proxy:unix:/run/php/php7.0-fpm.sock|fcgi://localhost"' /etc/apache2/conf-enabled/phpmyadmin.conf
elif [ "$WEBDEV_ENABLE_PHP_56_FPM" = 1 ]; then
	echo "==============Setting phpMyAdmin socket to 5.6 ..."
	sed -i '/#phpmyadminhandlerstart/a SetHandler "proxy:unix:/run/php/php5.6-fpm.sock|fcgi://localhost"' /etc/apache2/conf-enabled/phpmyadmin.conf
elif [ "$WEBDEV_ENABLE_PHP_55_FPM" = 1 ]; then
	echo "==============Setting phpMyAdmin socket to 5.5 ..."
	sed -i '/#phpmyadminhandlerstart/a SetHandler "proxy:unix:/run/php/php5.5-fpm.sock|fcgi://localhost"' /etc/apache2/conf-enabled/phpmyadmin.conf
elif [ "$WEBDEV_ENABLE_PHP_54_FPM" = 1 ]; then
	echo "==============Setting phpMyAdmin socket to 5.4 ..."
	sed -i '/#phpmyadminhandlerstart/a SetHandler "proxy:unix:/run/php/php5.4-fpm.sock|fcgi://localhost"' /etc/apache2/conf-enabled/phpmyadmin.conf
elif [ "$WEBDEV_ENABLE_PHP_53_FPM" = 1 ]; then
	echo "==============Setting phpMyAdmin socket to 5.3 ..."
	sed -i '/#phpmyadminhandlerstart/a SetHandler "proxy:unix:/run/php/php5.3-fpm.sock|fcgi://localhost"' /etc/apache2/conf-enabled/phpmyadmin.conf
fi

# Update Blackfire agent & client & start service
rm /etc/blackfire/agent
rm /root/.blackfire.ini
if [ "BLACKFIRE_SERVER_ID" != "" ] && [ "BLACKFIRE_SERVER_TOKEN" != "" ] && [ "BLACKFIRE_CLIENT_ID" != "" ] && [ "BLACKFIRE_CLIENT_TOKEN" != "" ]; then
    blackfire-agent -register <<< $"$BLACKFIRE_SERVER_ID\n$BLACKFIRE_SERVER_TOKEN\n"
    blackfire config <<< $"$BLACKFIRE_CLIENT_ID\n$BLACKFIRE_CLIENT_TOKEN\n"
fi

# Update PHP xdebug.remote_host IP
if [ "$WEBDEV_REMOTE_HOST_IP" != "" ]; then
	sed -i -e "s~xdebug.remote_host=[0-9.a-zA-Z]*~xdebug.remote_host=$WEBDEV_REMOTE_HOST_IP~g" /etc/php/5.6/fpm/php.ini
	sed -i -e "s~xdebug.remote_host=[0-9.a-zA-Z]*~xdebug.remote_host=$WEBDEV_REMOTE_HOST_IP~g" /etc/php/7.0/fpm/php.ini 
fi

# Only start PHP 5.3 FPM if WEBDEV_ENABLE_PHP_53_FPM is 1
if [ "$WEBDEV_ENABLE_PHP_53_FPM" = 1 ]; then
	echo "==============Starting PHP 5.3 FPM..."
	service php53-fpm start
fi

# Only start PHP 5.4 FPM if WEBDEV_ENABLE_PHP_54_FPM is 1
if [ "$WEBDEV_ENABLE_PHP_54_FPM" = 1 ]; then
	echo "==============Starting PHP 5.4 FPM..."
	service php54-fpm start
fi

# Only start PHP 5.5 FPM if WEBDEV_ENABLE_PHP_55_FPM is 1
if [ "$WEBDEV_ENABLE_PHP_55_FPM" = 1 ]; then
	echo "==============Starting PHP 5.5 FPM..."
	service php55-fpm start
fi

# Only start PHP 5.6 FPM if WEBDEV_ENABLE_PHP_70_FPM is 1
if [ "$WEBDEV_ENABLE_PHP_56_FPM" = 1 ]; then
	echo "==============Starting PHP 5.6 FPM..."
	service php5.6-fpm start
fi

# Only start PHP 7.0 FPM if WEBDEV_ENABLE_PHP_70_FPM is 1
if [ "$WEBDEV_ENABLE_PHP_70_FPM" = 1 ]; then
	echo "==============Starting PHP 7.0 FPM..."
	service php7.0-fpm start
fi

# Only start PHP 7.1 FPM if WEBDEV_ENABLE_PHP_71_FPM is 1
if [ "$WEBDEV_ENABLE_PHP_71_FPM" = 1 ]; then
	echo "==============Starting PHP 7.1 FPM..."
	service php7.1-fpm start
fi

# Only start PHP 7.2 FPM if WEBDEV_ENABLE_PHP_72_FPM is 1
if [ "$WEBDEV_ENABLE_PHP_72_FPM" = 1 ]; then
	echo "==============Starting PHP 7.2 FPM..."
	service php7.2-fpm start
fi

# Only start PHP 7.3 FPM if WEBDEV_ENABLE_PHP_73_FPM is 1
if [ "$WEBDEV_ENABLE_PHP_73_FPM" = 1 ]; then
	echo "==============Starting PHP 7.3 FPM..."
	service php7.3-fpm start
fi

# Only start PHP 7.4 FPM if WEBDEV_ENABLE_PHP_74_FPM is 1
if [ "$WEBDEV_ENABLE_PHP_74_FPM" = 1 ]; then
	echo "==============Starting PHP 7.4 FPM..."
	service php7.4-fpm start
fi

# Setup Postfix custom relayhost. e.g. for Mailhog (https://hub.docker.com/r/mailhog/mailhog/)
if [ -z ${WEBDEV_POSTFIX_RELAYHOST+x} ]; then
    echo "";
else
    echo "Update postfix config to use relayhost - '$WEBDEV_POSTFIX_RELAYHOST'";
    sed -i -e "s~relayhost =.*$~relayhost = $WEBDEV_POSTFIX_RELAYHOST~g" /etc/postfix/main.cf
    service postfix start
fi

################################
#
# Following are copied from https://github.com/lestrrat/docker-apache-php7-alpine/blob/master/apache2-foreground
#
################################

echo "==============Starting Apache..."
# Note: we don't just use "apache2ctl" here because it itself is just a shell-script wrapper around apache2 which provides extra functionality like "apache2ctl start" for launching apache2 in the background.
# (also, when run as "apache2ctl <apache args>", it does not use "exec", which leaves an undesirable resident shell process)

: "${APACHE_CONFDIR:=/etc/apache2}"
: "${APACHE_ENVVARS:=$APACHE_CONFDIR/envvars}"
if test -f "$APACHE_ENVVARS"; then
	. "$APACHE_ENVVARS"
fi

# Apache gets grumpy about PID files pre-existing
: "${APACHE_RUN_DIR:=/var/run/apache2}"
: "${APACHE_PID_FILE:=$APACHE_RUN_DIR/apache2.pid}"
rm -f "$APACHE_PID_FILE"

# create missing directories
# (especially APACHE_RUN_DIR, APACHE_LOCK_DIR, and APACHE_LOG_DIR)
for e in "${!APACHE_@}"; do
	if [[ "$e" == *_DIR ]] && [[ "${!e}" == /* ]]; then
		# handle "/var/lock" being a symlink to "/run/lock", but "/run/lock" not existing beforehand, so "/var/lock/something" fails to mkdir
		#   mkdir: cannot create directory '/var/lock': File exists
		dir="${!e}"
		while [ "$dir" != "$(dirname "$dir")" ]; do
			dir="$(dirname "$dir")"
			if [ -d "$dir" ]; then
				break
			fi
			absDir="$(readlink -f "$dir" 2>/dev/null || :)"
			if [ -n "$absDir" ]; then
				mkdir -p "$absDir"
			fi
		done

		mkdir -p "${!e}"
	fi
done

exec apache2 -DFOREGROUND "$@"
