FROM alpine:3.8 AS builder

RUN apk add --update --no-cache openjdk8 apache-ant ca-certificates

# Get svn TRUNK
# RUN apk add --update --no-cache subversion\
#  && svn co https://svn.code.sf.net/p/davmail/code/trunk /davmail-code

# Get released VERSION.
ARG DAVMAIL_VER=4.8.6
ARG DAVMAIL_REV=2600
RUN apk add --update --no-cache curl\
 && curl -sL https://sourceforge.net/projects/davmail/files/davmail/${DAVMAIL_VER}/davmail-src-${DAVMAIL_VER}-${DAVMAIL_REV}.tgz | tar xzv\
 && find ./davmail-* -type d -maxdepth 0 -exec ln -vs "{}" "/davmail-code" \;

# Build
RUN cd /davmail-code\
 && ant\
 && chmod +x /davmail-code/dist/davmail.sh

FROM openjdk:8-jre-alpine

COPY --from=builder\
 /davmail-code/dist/davmail.jar\
 /davmail-code/dist/davmail.sh\
 /davmail/
COPY --from=builder /davmail-code/dist/lib /davmail/lib

EXPOSE 1110
EXPOSE 1025
EXPOSE 1143
EXPOSE 1080
EXPOSE 1389

ENTRYPOINT [ "/davmail/davmail.sh" ]
CMD [ "/davmail/davmail.properties" ]
