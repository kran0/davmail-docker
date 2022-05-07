[DavMail][link_davmail_home] POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange Gateway

# What is it?

This dockerised version makes building, installing, running and upgrading DavMail extremely easy.
The information, code and support: http://davmail.sourceforge.net/ .

# How to run?

## Simple docker-compose

- Please read the davmail.properties [example and references](http://davmail.sourceforge.net/serversetup.html);
- Place your config to ```./conf/davmail.properties``` use example:```./conf/davmail.properties.example```;
- Edit docker-compose.yaml to use volume ```./conf/davmail.properties``` instead of ```./conf/davmail.properties.example```;
- Run service:

```bash
  docker-compose up -d
  dockr-compose down
```

## Simple docker run

```bash
$ docker run -it --rm\
   -v $PWD/conf/davmail.properties.example:/davmail/davmail.properties\
   -p 1025:1025\
   -p 1110:1110\
   kran0/davmail-docker:latest
```

Example run command publishes 1025 (SMTP) and 1110 (POP).
Add more `-p HOST_PORT:CONTAINER_PORT` to get more:

| Description | TCP port number |
|:-:|---|
| CalDav | 1080 |
| IMAP   | 1143 |
| LDAP   | 1389 |
| POP    | 1110 |
| SMTP   | 1025 |

# Docker tags

[![Builds][badge_build_status]][link_docker_tags]

| Repository:Tag | Description |
|:--|---|
| kran0/davmail-docker:latest     | latest stable release with the latest Dockerfile |
| kran0/davmail-docker:x.y.z      | tagged stable release [![Semver][badge_docker_semver]][link_docker_tags] |

---
[badge_build_status]:https://github.com/kran0/davmail-docker/actions/workflows/build_images.yml/badge.svg
[badge_docker_semver]:https://img.shields.io/docker/v/kran0/davmail-docker?sort=semver&style=social&cacheSeconds=3600
[link_docker_tags]:https://hub.docker.com/r/kran0/davmail-docker/tags?page=1&ordering=last_updated
[link_davmail_home]:http://davmail.sourceforge.net/
[link_tinyimage]:https://hub.docker.com/r/kran0/tiny/tags
