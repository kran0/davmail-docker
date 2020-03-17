[DavMail](http://davmail.sourceforge.net/) POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange Gateway

# What is it?

This dockerised version makes building, installing, running and upgrading DavMail extremely easy.
The information, code and support: http://davmail.sourceforge.net/ .

# How to run?

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

The davmail.properties [example and references](http://davmail.sourceforge.net/serversetup.html).

# Docker tags

[Automated builds](https://hub.docker.com/r/kran0/davmail-docker/tags/).

| Repository:Tag | Build description  |
|:-:|---|
| kran0/davmail-docker:latest      | latest stable release with the latest Dockerfile |
| kran0/davmail-docker:tiny        | latest stable release with the latest Dockerfile built FROM [kran0/tiny:openjdk8-jre](https://hub.docker.com/r/kran0/tiny/tags) |
| kran0/davmail-docker:trunk       | HEAD rev in SVN repo. *May be unstable!* |
| kran0/davmail-docker:trunk-tiny  | HEAD rev in SVN repo. *May be unstable!* built FROM [kran0/tiny:openjdk8-jre](https://hub.docker.com/r/kran0/tiny/tags) |
| kran0/davmail-docker:x.y.z       | tagged stable release |
| kran0/davmail-docker:x.y.z-tiny  | tagged stable release built FROM [kran0/tiny:openjdk8-jre](https://hub.docker.com/r/kran0/tiny/tags) |
