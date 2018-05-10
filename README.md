# How to run

docker run -it --rm\
 -v $PWD/conf/davmail.properties.example:/davmail/davmail.properties:ro\
 davmail:version