[DavMail][link_davmail_home] POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange Gateway

# What is it?

This dockerised version makes building, installing, running and upgrading DavMail extremely easy.
The information, code and support: http://davmail.sourceforge.net/ .

# How to run?

## Simple docker-compose

- Please read the davmail.properties [example and references](http://davmail.sourceforge.net/serversetup.html);
- Edit [docker-compose.yaml](docker-compose.yaml) to set environment variables;
- Run service:

```bash
  docker-compose up -d
  docker-compose down
```

_Entrypoint script will try to store the created persistent variables on the davmail-config volume file system._
_If this volume is deleted, some of the persistent configuration data may be lost._
_You can force disable davmail-config persistance usage by setting `DISABLE_DAVMAIL_PROPERTIES_PERSISTENCE=true`_

## Simple docker run

```bash
 docker run -it --rm\
   -e DAVMAIL_SERVER=true
   -p 1025:1025\
   -p 1110:1110\
   kran0/davmail-docker:latest
```

Example run command publishes 1025 (SMTP) and 1110 (POP), and uses only one environment varialbe.
Please watch the example configs in [docker-compose.yaml](docker-compose.yaml) and [tests/compose-sut.yaml](tests/compose-sut.yaml)
and the official DavMail configuration [example and references](http://davmail.sourceforge.net/serversetup.html)

### Run using old-fasion text-based config

/Just add config path as command after the image TAG/

```bash
 docker run -it --rm\
   -v $PWD/conf/davmail.properties.example:/davmail/davmail.properties\
   -p 1025:1025\
   -p 1110:1110\
   kran0/davmail-docker:latest /davmail/davmail.properties
```

## Import to Kubernetes

```bash
 kubectl create -f k8s-pod.yaml
```

# Docker tags

[![Builds][badge_build_status]][link_docker_tags]

| Repository:Tag | Description |
|:--|---|
| kran0/davmail-docker:latest     | latest stable release with the latest Dockerfile |
| kran0/davmail-docker:x.y.z      | stable releases [![Semver][badge_docker_semver]][link_docker_tags] |
| kran0/davmail-docker:trunk      | HEAD rev in SVN repo. *May be unstable!* |

---
[badge_build_status]:https://github.com/kran0/davmail-docker/actions/workflows/build_images.yml/badge.svg
[badge_docker_semver]:https://img.shields.io/docker/v/kran0/davmail-docker?sort=semver&style=social&cacheSeconds=3600
[link_docker_tags]:https://hub.docker.com/r/kran0/davmail-docker/tags?page=1&ordering=last_updated
[link_davmail_home]:http://davmail.sourceforge.net/
[link_tinyimage]:https://hub.docker.com/r/kran0/tiny/tags
