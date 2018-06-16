[DavMail](http://davmail.sourceforge.net/) POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange Gateway

# How to run

```bash
$ docker run -it --rm\
   -v $PWD/conf/davmail.properties.example:/davmail/davmail.properties:ro\
   -p 1025:1025\
   -p 1110:1110\
   kran0/davmail-docker:latest
```

Example run command publishes 1025 (SMTP) and 1110 (POP).
Add more `-p HOSTS_PORT:CONTAINER_PORT` to get more: 1143 (imap); 1389 (ldap); 1080 (caldav).

The davmail.properties example and references are in the [official documentation](http://davmail.sourceforge.net/serversetup.html).
