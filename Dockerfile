FROM icr.io/appcafe/websphere-liberty:22.0.0.6-full-java8-ibmjava-ubi

COPY target/modresorts-1.0.war /config/apps/modresorts-1.0.war
COPY server.xml                /config/server.xml
COPY jvm.options               /config/jvm.options
