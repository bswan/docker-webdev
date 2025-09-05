# docker webdev image

This is a LAP base image. Wildcard host webdev will be built on top of this image.

- ubuntu {{UBUNTU_LTS_VERSION}}
- apache2
- {{PHP_VERSIONS_LIST}}via [php ppa]([https://launchpad.net/~ondrej/+archive/ubuntu/php])
- Composer 1&2
- NPM
- NodeJS
- NVM
- SSPack
- Chrome
- XDebug