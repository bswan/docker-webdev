# webdev docker build file


## Using Locally

To use these containers locally, they will need to be built & tagged into images first.

1. Start with the [./lap/Dockerfile](./lap/Dockerfile)
2. Build the image - options to build are:
   * `docker build -t xpon/webdev_local:latest .` 
   * VSCode or another IDE - often, you can right-click on the Dockerfile & choose "build" - make sure you keep track of the image name it gives it
3. In the above command, `xpon/webdev_local` is the image name and `latest` is the tag
4. Next, edit the [./lap-wildcard/Dockerfile](./lap-wildcard/Dockerfile)
5. Change the first line from `FROM internetrix/webdev:lap` to `FROM xpon/webdev_local:latest` (or whatever your image is called from step 2 above - use `docker images` to list them or use the Docker UI in your OS to see what images and their names you have)
6.  Build this image - options to build are:
   * `docker build -t xpon/webdev_wildcard_local:latest .` 
   * VSCode or another IDE - often, you can right-click on the Dockerfile & choose "build" - make sure you keep track of the image name it gives it
7. Next edit the [./docker-compose.yml](./docker-compose.yml)
8. Change the `image` reference in the `web` service to reflect the newly built image - change from: `image: internetrix/webdev:lap-wildcard` to `image: xpon/webdev_wildcard_local:latest`
9. Rebuild the docker compose service: `docker compose up --force-recreate` (you likely do not need the force-recreate, but best to do so)


If you have any problems, it may be worthwhile deleting all other containers both running and stopped (use `docker ps -a` to show all & `docker rm {container name}` to delete them).
