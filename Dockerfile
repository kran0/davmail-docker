FROM alpine:3.8 AS builder

#4.8.5 rev 2589
#4.8.6 rev 2600
#4.9.0 rev 2652
ARG DAVMAIL_REV=2652


RUN apk add --update --no-cache ca-certificates curl\
\
# Download OpenJFX (JavaFX) apk
 && curl -sLo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub\
   --next -Lo /tmp/java-openjfx.apk https://github.com/sgerrand/alpine-pkg-java-openjfx/releases/download/8.151.12-r0/java-openjfx-8.151.12-r0.apk\
\
# Install tools
 && apk add --update --no-cache openjdk8 apache-ant subversion /tmp/java-openjfx.apk


# Get svn TRUNK or released REVISION based on build-arg: DAVMAIL_REV
RUN svn co -r ${DAVMAIL_REV} https://svn.code.sf.net/p/davmail/code/trunk /davmail-code\
\
# Build
 && cd /davmail-code\
 && ant
# && chmod +x /davmail-code/dist/davmail.sh


# Prepare result
RUN mkdir -vp /target/davmail\
 && mv -v /davmail-code/dist/davmail.jar\
          /davmail-code/dist/lib\
      /target/davmail/


FROM openjdk:8-jre-alpine
COPY --from=builder /target /

EXPOSE 1110 1025 1143 1080 1389
java -Xmx512M -Dsun.net.inetaddr.ttl=60 -cp /davmail/davmail.jar:lib/* davmail.DavGateway
#ENTRYPOINT [ "/davmail/davmail.sh" ]
CMD [ "/davmail/davmail.properties" ]
