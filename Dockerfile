FROM alpine:3.10 AS builder

#trunk rev HEAD (may be unstable)
#4.8.5 rev 2589
#4.8.6 rev 2600
#4.9.0 rev 2652
#5.0.0 rev 2801
#5.1.0 rev 2891
#5.2.0 rev 2961
#5.3.1 rev 3079
#5.4.0 rev 3135
ARG DAVMAIL_REV=3135

# Install tools
RUN apk add --update --no-cache openjdk8 apache-ant subversion

# Get svn TRUNK or released REVISION based on build-arg: DAVMAIL_REV
RUN svn co -r ${DAVMAIL_REV} https://svn.code.sf.net/p/davmail/code/trunk /davmail-code

# Build
RUN cd /davmail-code && ant #jar

# Unused depencies, we dont need no junit tests, graphics support and winrun
RUN rm -fv\
 /davmail-code/dist/lib/ant-deb*.jar\
 /davmail-code/dist/lib/junit-*\
 /davmail-code/dist/lib/libgrowl*\
 /davmail-code/dist/lib/nsisant-*.jar\
 /davmail-code/dist/lib/servlet-api-*.jar\
 /davmail-code/dist/lib/swt-*\
 /davmail-code/dist/lib/winrun4j-*\
 || true # if something is missing

# Prepare result
RUN mkdir -vp /target/davmail
RUN mv -v /davmail-code/dist/davmail.jar\
          /davmail-code/dist/lib\
      /target/davmail/

## Build completed, the result is in in the builder:/target directory ##

FROM openjdk:8-jre-alpine
#FROM kran0/tiny:openjdk8-jre
COPY --from=builder /target /

EXPOSE 1110 1025 1143 1080 1389
ENTRYPOINT [ "java", "-Xmx512M", "-Dsun.net.inetaddr.ttl=60",\
             "-cp", "/davmail/davmail.jar:/davmail/lib/*",\
             "davmail.DavGateway", "-notray" ]
CMD [ "/davmail/davmail.properties" ]
