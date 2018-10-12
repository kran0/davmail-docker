FROM alpine:3.8 AS builder

RUN apk add --update --no-cache ca-certificates curl\
\
# Download OpenJFX (JavaFX) apk
 && curl -sLo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub\
   --next -Lo /tmp/java-openjfx.apk https://github.com/sgerrand/alpine-pkg-java-openjfx/releases/download/8.151.12-r0/java-openjfx-8.151.12-r0.apk\
\
# Install tools
 && apk add --update --no-cache openjdk8 apache-ant subversion /tmp/java-openjfx.apk


#4.9.0 rev 2652
ENV DAVMAIL_REV=2652
ENV DAVMAIL_REV_test

RUN echo DEBUG ${DAVMAIL_REV_test} -

# Get svn TRUNK or released REVISION
#RUN svn co https://svn.code.sf.net/p/davmail/code/trunk /davmail-code\
RUN svn co -r ${DAVMAIL_REV} https://svn.code.sf.net/p/davmail/code/trunk /davmail-code\
\
# Build
 && cd /davmail-code\
 && ant\
 && chmod +x /davmail-code/dist/davmail.sh\
\
# Prepare result
 && mkdir -vp /target/davmail\
 && mv -v /davmail-code/dist/davmail.jar\
          /davmail-code/dist/davmail.sh\
          /davmail-code/dist/lib\
      /target/davmail/

FROM openjdk:8-jre-alpine
COPY --from=builder /target /

EXPOSE 1110 1025 1143 1080 1389
ENTRYPOINT [ "/davmail/davmail.sh" ]
CMD [ "/davmail/davmail.properties" ]
