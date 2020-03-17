FROM alpine:3.11 AS builder

#trunk rev HEAD (may be unstable)
#5.4.0 rev 3135
ARG DAVMAIL_REV=3135

#exclude these deps in target
ARG EXCLUDE_DEPS='NOTHING_EXCLUDE'

# Install tools
RUN apk add --update --no-cache openjdk8 maven subversion

# Get svn TRUNK or released REVISION based on build-arg: DAVMAIL_REV
RUN svn co -r ${DAVMAIL_REV} https://svn.code.sf.net/p/davmail/code/trunk /davmail-code

# Build + List deps to tempfile
RUN cd /davmail-code\
 && mvn clean package\
 && mvn dependency:resolve -DoutputAbsoluteArtifactFilename=true -DoutputFile=/tmp/deps

# Create target directory
RUN mkdir -vp /target/davmail /target/davmail/lib

# Move deps to target-lib
RUN mv -v $(sed -ne 's/^.*:\([^:]*\.jar\)$/\1/p' /tmp/deps\
            | grep -v '/(\|'$(printf '%s\|' ${EXCLUDE_DEPS//;/ })')-.*\.jar$'\
    ) /target/davmail/lib/

# Move davmail to target
RUN mv -v /davmail-code/target/davmail-*.jar /target/davmail/
RUN cd /target/davmail\
 && ln -s davmail-*.jar davmail.jar

## Build completed, the result is in in the builder:/target directory ##

FROM openjdk:8-jre-alpine
#FROM kran0/tiny:openjdk8-jre
COPY --from=builder /target /

EXPOSE 1110 1025 1143 1080 1389
ENTRYPOINT [ "java", "-Xmx512M", "-Dsun.net.inetaddr.ttl=60",\
             "-cp", "/davmail/davmail.jar:/davmail/lib/*",\
             "davmail.DavGateway", "-notray" ]
CMD [ "/davmail/davmail.properties" ]
