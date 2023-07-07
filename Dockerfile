FROM icr.io/appcafe/websphere-liberty:full-java17-openj9-ubi

COPY target/modresorts-1.0.war /config/apps/modresorts-1.0.war
COPY server.xml                /config/server.xml
COPY jvm.options               /config/jvm.options

RUN configure.sh
#RUN checkpoint.sh afterAppStart
