#!/bin/bash

# CIFS config for Windows
# Mount CIFS folder if not exists (Mac might use bind mount on /media/www)

	echo '==Checking if folder needs to be mounted';

if [ ! -d /media/www ] || [ "$(ls -A /media/www 2> /dev/null)" == "" ]; then
	echo '==Folder needs to be mounted because media www folder is empty';

	# On some computers mount with no vers flag will break while on some computers if there is a vers flag, it will also break
	# Give user choice to define whether they want to use the ver flag
    if [ "$WEBDEV_CIFS_SMB_VERSION" == 3.1 ]; then
	    echo "$WEBDEV_CIFS_HOST_FOLDER  /media/www  cifs  vers=$WEBDEV_CIFS_SMB_VERSION,uid=www-data,gid=www-data,file_mode=0777,dir_mode=0777,username=$WEBDEV_CIFS_USER,password=$WEBDEV_CIFS_PW,iocharset=utf8  0  0" > /etc/fstab
    elif [ "$WEBDEV_CIFS_SMB_VERSION" == 3.0 ]; then
	    echo "$WEBDEV_CIFS_HOST_FOLDER  /media/www  cifs  vers=$WEBDEV_CIFS_SMB_VERSION,uid=www-data,gid=www-data,file_mode=0777,dir_mode=0777,username=$WEBDEV_CIFS_USER,password=$WEBDEV_CIFS_PW,iocharset=utf8  0  0" > /etc/fstab
    elif [ "$WEBDEV_CIFS_SMB_VERSION" == 2.0 ]; then
	    echo "$WEBDEV_CIFS_HOST_FOLDER  /media/www  cifs  vers=$WEBDEV_CIFS_SMB_VERSION,uid=www-data,gid=www-data,file_mode=0777,dir_mode=0777,username=$WEBDEV_CIFS_USER,password=$WEBDEV_CIFS_PW,iocharset=utf8  0  0" > /etc/fstab
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

# If we are adding our SSH keys from localhost, update permissions so its protected
if [ -d /root/.ssh/ ]; then
	chmod -R 400 /root/.ssh/
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

# Setup composer github token, if provided
GITHUB_TOKEN_FILE="/root/secrets/GITHUB_TOKEN"
if [[ -f "$GITHUB_TOKEN_FILE" ]]; then
    TOKEN=$(<"$GITHUB_TOKEN_FILE")
	if [ "$TOKEN" != "" ]; then
		echo "{\"github-oauth\": {\"github.com\": \"$TOKEN\"}}" > /root/.config/composer/auth.json
		echo "Composer Auth file created"
else
	echo "No GitHub token provided"
fi
else
    echo "No GitHub token provided"
fi

## setup phpmyadmin config to use correct php.fpm handler, depending on php version set
# Remove old phpmyadmin handler config
sed -i '/#phpmyadminhandlerstart/,/#phpmyadminhandlerend/{//!d}' /etc/apache2/conf-enabled/phpmyadmin.conf
# Set new phpmyadmin handler config: /etc/apache2/conf-enabled/phpmyadmin.conf
{{PMA_HANDLER_SELECTOR}}

if [ "$COMPOSER_DEFAULT_VERSION" = 1 ]; then
  	echo "==============Selecting a Composer v1.x to answer to composer command"
	RUN update-alternatives --set composer /usr/local/bin/composer1
elif [ "$COMPOSER_DEFAULT_VERSION" = 2 ]; then
  	echo "==============Selecting a Composer v2.x to answer to composer command"
	RUN update-alternatives --set composer /usr/local/bin/composer2
fi

# Update PHP xdebug.remote_host IP
if [ "$WEBDEV_REMOTE_HOST_IP" != "" ]; then
	{{XDEBUG_IP}}
fi

{{XDEBUG_MODE}}

mkdir /tmp/xdebug
{{XDEBUG_DIRS}}
chmod -R 0777 /tmp/xdebug/

{{PHP_SERVICES}}

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
