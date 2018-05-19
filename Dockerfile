FROM alpine:edge AS builder

RUN apk add --update --no-cache openjdk8 apache-ant ca-certificates

# Get svn TRUNK
# RUN apk add --update --no-cache subversion\
# RUN svn co https://svn.code.sf.net/p/davmail/code/trunk /davmail-code

# Get released VERSION.

ENV DAVMAIL_VER 4.8.5\
    DAVMAIL_REV 2589
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

ENTRYPOINT [ "/davmail/davmail.sh" ]
CMD [ "/davmail/davmail.properties" ]
