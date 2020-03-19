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

[![Automated][badge_docker_automated]][link_docker_tags]
[![Build][badge_docker_build]][link_docker_builds]

| Repository:Tag | Description |
|:--|---|
| kran0/davmail-docker:latest     | latest stable release with the latest Dockerfile |
| kran0/davmail-docker:trunk      | HEAD rev in SVN repo. *May be unstable!*         |
| kran0/davmail-docker:x.y.z      | tagged stable release [![Semver][badge_docker_semver]][link_docker_tags] |
| kran0/davmail-docker:tiny       | **experimental** latest stable release with the latest Dockerfile built FROM [kran0/tiny:openjdk8-jre][link_tinyimage] |
| kran0/davmail-docker:trunk-tiny | **experimental** HEAD rev in SVN repo. *May be unstable!* built FROM [kran0/tiny:openjdk8-jre][link_tinyimage]         |
| kran0/davmail-docker:x.y.z-tiny | **experimental** tagged stable release built FROM [kran0/tiny:openjdk8-jre][link_tinyimage]                            |

---
[badge_docker_automated]:https://img.shields.io/docker/automated/kran0/davmail-docker?style=for-the-badge&cacheSeconds=3600
[badge_docker_build]:https://img.shields.io/docker/build/kran0/davmail-docker?style=for-the-badge&cacheSeconds=3600
[badge_docker_semver]:https://img.shields.io/docker/v/kran0/davmail-docker?sort=semver&style=social&cacheSeconds=3600
[link_docker_tags]:https://hub.docker.com/r/kran0/davmail-docker/tags?page=1&ordering=last_updated
[link_docker_builds]:https://hub.docker.com/r/kran0/davmail-docker/builds
[link_davmail_home]:http://davmail.sourceforge.net/
[link_tinyimage]:https://hub.docker.com/r/kran0/tiny/tags
