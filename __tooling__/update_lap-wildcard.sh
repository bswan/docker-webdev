#!/bin/bash

echo "Updating LAP-Wildcard Dockerfile and Apache Configs with latest supported PHP versions..."

get_supported_php_versions() {
    # Fetch JSON of currently supported (non-EoL) PHP versions
    curl -s "https://php.watch/api/v1/versions/secure" \
      | jq -r '.data[] .name' \
      | sort -V
}

if [ "$#" -gt 0 ]; then
    PHP_VERSIONS=("$@")
    echo "Using versions (from CLI): ${PHP_VERSIONS[*]}"
else
    echo "Fetching supported PHP versions..."
    mapfile -t PHP_VERSIONS < <(get_supported_php_versions)
    echo "Discovered supported versions: ${PHP_VERSIONS[*]}"
fi

if [ "${#PHP_VERSIONS[@]}" -eq 0 ]; then
    echo "No PHP versions found or provided"
    exit 1
fi

TEMPLATE_FOREGROUND="templates/lap-wildcard/apache-foreground.sh"
TEMPLATE_DOCKERFILE="templates/lap-wildcard/Dockerfile"
OUTPUT_FOREGROUND="../lap-wildcard/apache-foreground.sh"
OUTPUT_DOCKERFILE="../lap-wildcard/Dockerfile"
APACHE_VHOSTS_DIR="../lap-wildcard/config/apache/sites"

PMA_HANDLER_SELECTOR="\nfi"
PHP_INI_FILES=""
APACHE_VHOSTS=""
APACHE_SITES=""
PHP_SERVICES=""
XDEBUG_DIRS=""
XDEBUG_MODE=""
XDEBUG_IP=""
ENVS=""

rm -f $APACHE_VHOSTS_DIR/apache-wildcard-php*-vhost.conf
RECENT="${PHP_VERSIONS[-1]}"
for VERSION in "${PHP_VERSIONS[@]}"; do
    V="${VERSION//./}" # Version name without dot 8.3=>83

    PHP_INI_FILES+=" /etc/php/${VERSION}/fpm/php.ini"
    
    APACHE_VHOSTS+="ADD config/apache/sites/apache-wildcard-php${V}-vhost.conf /etc/apache2/sites-available/001-wildcard-php${V}-vhost.conf\n"
    APACHE_SITES+="\n\t001-wildcard-php${V}-vhost.conf \\\\"
    
    ENVS+="ENV WEBDEV_ENABLE_PHP_${V}_FPM=1\nENV XDEBUG_PHP_${V}_MODE='develop'\n"

    XDEBUG_IP+="\tsed -i -e \"s~xdebug.client_host=[0-9.a-zA-Z]*~xdebug.client_host=\$WEBDEV_REMOTE_HOST_IP~g\" /etc/php/${VERSION}/fpm/php.ini\n"
    XDEBUG_DIRS+="sed -i -e \"s~xdebug.output_dir=[0-9./a-zA-Z]*~xdebug.output_dir=/tmp/xdebug/php${V}~g\" /etc/php/${VERSION}/fpm/php.ini \nmkdir /tmp/xdebug/php${V}\n"
    XDEBUG_MODE+="sed -i -e \"s~xdebug.mode=[0-9.,a-zA-Z]*~xdebug.mode=\$XDEBUG_PHP_${V}_MODE~g\" /etc/php/${VERSION}/fpm/php.ini\n"


    VHOST_FILE="$APACHE_VHOSTS_DIR/apache-wildcard-php${V}-vhost.conf"
    cp "templates/lap-wildcard/apache-wildcard-phpXX-vhost.conf" $VHOST_FILE
    sed -i "s|{{VERSION}}|$VERSION|" $VHOST_FILE
    sed -i "s|{{VERSION_SHORT}}|$V|" $VHOST_FILE
    
    if [[ $VERSION == $RECENT ]]; then
        PMA_HANDLER_SELECTOR="if [ \"\$WEBDEV_ENABLE_PHP_${V}_FPM\" = 1 ]; then \n\
    echo \"==============Setting phpMyAdmin handler to ${VERSION} ...\" \n\
    sed -i '/#phpmyadminhandlerstart/a SetHandler \"proxy:unix:/run/php/php${VERSION}-fpm.sock\|fcgi://localhost\"' /etc/apache2/conf-enabled/phpmyadmin.conf\n$PMA_HANDLER_SELECTOR"
    else
        PMA_HANDLER_SELECTOR="elif [ \"\$WEBDEV_ENABLE_PHP_${V}_FPM\" = 1 ]; then \n\
    echo \"==============Setting phpMyAdmin handler to ${VERSION} ...\" \n\
    sed -i '/#phpmyadminhandlerstart/a SetHandler \"proxy:unix:/run/php/php${VERSION}-fpm.sock\|fcgi://localhost\"' /etc/apache2/conf-enabled/phpmyadmin.conf\n$PMA_HANDLER_SELECTOR"
    fi

    PHP_SERVICES+="\n# Only start PHP ${VERSION} FPM if WEBDEV_ENABLE_PHP_${V}_FPM is 1\n\
    if [ \"\$WEBDEV_ENABLE_PHP_${V}_FPM\" = 1 ]; then\n\
        echo \"==============Starting PHP ${VERSION} FPM...\"\n\
        service php${VERSION}-fpm start\n\
    fi\n"
done

sed \
    -e "s|{{PHP_INI_FILES}}|$PHP_INI_FILES|" \
    "$TEMPLATE_DOCKERFILE" > "$OUTPUT_DOCKERFILE"

sed -i "s|{{APACHE_VHOSTS}}|${APACHE_VHOSTS}|" $OUTPUT_DOCKERFILE
sed -i "s|{{APACHE_SITES}}|${APACHE_SITES}|" $OUTPUT_DOCKERFILE

sed -i "s|{{ENVS}}|$ENVS|" $OUTPUT_DOCKERFILE

sed \
    -e "s|{{PMA_HANDLER_SELECTOR}}|$PMA_HANDLER_SELECTOR|" \
    "$TEMPLATE_FOREGROUND" > "$OUTPUT_FOREGROUND"

sed -i "s|{{XDEBUG_IP}}|$XDEBUG_IP|" $OUTPUT_FOREGROUND
sed -i "s|{{XDEBUG_DIRS}}|$XDEBUG_DIRS|" $OUTPUT_FOREGROUND
sed -i "s|{{XDEBUG_MODE}}|$XDEBUG_MODE|" $OUTPUT_FOREGROUND
sed -i "s|{{PHP_SERVICES}}|${PHP_SERVICES}|" $OUTPUT_FOREGROUND

echo "Done"
