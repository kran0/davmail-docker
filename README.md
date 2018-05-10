# How to build

You need docker-ce >= 17!
$ docker build -t davmail:version .

# How to run

$ docker run -it --rm\
   -v $PWD/conf/davmail.properties.example:/davmail/davmail.properties:ro\
   davmail:version