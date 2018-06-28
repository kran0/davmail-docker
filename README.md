[DavMail](http://davmail.sourceforge.net/) POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange Gateway

# What is it?

This dockerised version makes building, installing, running and upgrading DavMail extremely easy.
The information, code and support: http://davmail.sourceforge.net/ .

# How to run?

```bash
$ docker run -it --rm\
   -v $PWD/conf/davmail.properties.example:/davmail/davmail.properties:ro\
   -p 1025:1025\
   -p 1110:1110\
   kran0/davmail-docker:latest
```

Example run command publishes 1025 (SMTP) and 1110 (POP).
Add more `-p HOSTS_PORT:CONTAINER_PORT` to get more:

- CalDav: 1080;
- IMAP:   1143;
- LDAP:   1389;
- POP:    1110;
- SMTP:   1025.

The davmail.properties example and references are in the [official documentation](http://davmail.sourceforge.net/serversetup.html).

# Docker tags

- :latest contains the latest stable revision marked as a release by the author;
- :trunk contains latest revision published by the author in SVN repo. It builds automaticly and may be unstable;
- :4.8.5 and such contain previously released stable releases.
