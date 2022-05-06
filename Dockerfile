ARG BASE_IMAGE=openjdk:8-jre-alpine
FROM alpine:3.15 AS builder

#trunk rev HEAD (may be unstable)
#5.4.0 rev 3135
#5.5.0 rev 3293
#5.5.1 rev 3299
#6.0.1 rev 3390
ARG DAVMAIL_REV=3390

#exclude these deps in target
# Default headless: no junit tests, graphics support and winrun
ARG DEPS_EXCLUDE_ARTIFACTIDS='winrun4j,servlet-api,junit,swt,growl'
ARG DEPS_EXCLUDE_GROUPIDS='org.boris.winrun4j,javax.servlet,junit,org.eclipse,info.growl'

# Install tools
RUN apk add --update --no-cache openjdk8 maven subversion

# Get svn TRUNK or released REVISION based on build-arg: DAVMAIL_REV
RUN svn co -r ${DAVMAIL_REV} https://svn.code.sf.net/p/davmail/code/trunk /davmail-code

# Build + List deps to tempfile
RUN cd /davmail-code\
 && mvn clean package\
 && mvn dependency:resolve\
     -DexcludeArtifactIds="${DEPS_EXCLUDE_ARTIFACTIDS}"\
     -DexcludeGroupIds="${DEPS_EXCLUDE_GROUPIDS}"\
     -DoutputAbsoluteArtifactFilename=true\
     -DoutputFile=/tmp/deps

# Create target directory
RUN mkdir -vp /target/davmail /target/davmail/lib

# Move dependencies and davmail to target, link davmail to pretty short name
RUN mv -v $( sed -ne 's/^.*:\([^:]*\.jar\)$/\1/p' /tmp/deps ) /target/davmail/lib/
RUN mv -v /davmail-code/target/davmail-*.jar /target/davmail/
RUN cd /target/davmail\
 && ln -s davmail-*.jar davmail.jar

## Build completed, the result is in in the builder:/target directory ##

FROM ${BASE_IMAGE}

COPY --from=builder /target /

EXPOSE 1110 1025 1143 1080 1389
ENTRYPOINT [ "java", "-Xmx512M", "-Dsun.net.inetaddr.ttl=60",\
             "-cp", "/davmail/davmail.jar:/davmail/lib/*",\
             "davmail.DavGateway", "-notray" ]
CMD [ "/davmail/davmail.properties" ]
