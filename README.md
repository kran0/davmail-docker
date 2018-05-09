# How to run

docker run -it --rm\
 -v $PWD/conf/.davmail.properties:/davmail/davmail.properties:ro\
 davmail:version