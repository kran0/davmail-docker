# How to build

You need docker-ce >= 17!
```bash
$ docker build -t davmail:4.8.5\
   --build-arg DAVMAIL_VER='4.8.5'\
   --build-arg DAVMAIL_REV='2589' .
```

# How to run

```bash
$ docker run -it --rm\
   -v $PWD/conf/davmail.properties.example:/davmail/davmail.properties:ro\
   davmail:4.8.5
```