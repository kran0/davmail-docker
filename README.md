# How to run

```bash
$ docker run -it --rm\
   -v $PWD/conf/davmail.properties.example:/davmail/davmail.properties:ro\
   -p 1025:1025\
   -p 1110:1110\
   kran0/davmail-docker:latest
```

Example run command publishes 1025 (SMTP) and 1110 (POP).
Add more `-p HOSTS_PORT:CONTAINER_PORT` to more.
