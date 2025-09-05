#!/bin/bash

echo "Updating LAP Dockerfile and README with latest supported PHP, PMA and Ubuntu LTS versions..."

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

TEMPLATE_DOCKERFILE="templates/lap/Dockerfile"
OUTPUT_DOCKERFILE="../lap/Dockerfile"
TEMPLATE_README="templates/lap/README.md"
OUTPUT_README="../lap/README.md"

INSTALL_COMMANDS=""
VERSION_LIST=""

PMA_VERSION=$(curl -s https://www.phpmyadmin.net/home_page/version.txt | head -n 1)
echo "Latest PMA version: ${PMA_VERSION}"

UBUNTU_LTS_VERSION=$(curl -s https://hub.docker.com/v2/repositories/library/ubuntu/tags/ | jq -r '.results[] | select(.name | test("^[0-9]+\\.04$")) | .name' | sort -V | tail -n 1)
echo "Latest Ubuntu LTS: $UBUNTU_LTS_VERSION"


for version in "${PHP_VERSIONS[@]}"; do
    INSTALL_COMMANDS+="\n# Install PHP $version and extensions\n"
    INSTALL_COMMANDS+="RUN apt-get -qqy install php${version} php${version}-cli php${version}-xdebug php${version}-fpm php${version}-mysql php${version}-curl php${version}-soap php${version}-common php${version}-gd php${version}-tidy php${version}-mbstring php${version}-xml php${version}-intl php${version}-memcache php${version}-yaml php${version}-zip \n"
    INSTALL_COMMANDS+="RUN echo \"date.timezone = Australia/Sydney\" > /etc/php/${version}/cli/conf.d/timezone.ini \&\& echo \"date.timezone = Australia/Sydney\" > /etc/php/${version}/fpm/conf.d/timezone.ini\n"
    VERSION_LIST+="PHP${version} "
done

sed \
    -e "s|{{PHP_INSTALL_CMDS}}|$INSTALL_COMMANDS|" \
    "$TEMPLATE_DOCKERFILE" > "$OUTPUT_DOCKERFILE"

sed -i "s/{{PMA_VERSION}}/$PMA_VERSION/" $OUTPUT_DOCKERFILE

sed -i "s/{{UBUNTU_LTS_VERSION}}/$UBUNTU_LTS_VERSION/" $OUTPUT_DOCKERFILE

sed \
    -e "s|{{PHP_VERSIONS_LIST}}|$VERSION_LIST|" \
    "$TEMPLATE_README" > "$OUTPUT_README"

sed -i "s/{{UBUNTU_LTS_VERSION}}/$UBUNTU_LTS_VERSION/" $OUTPUT_README

echo "Done"
