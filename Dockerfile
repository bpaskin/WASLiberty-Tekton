FROM ibmcom/websphere-traditional:9.0.5.10

COPY target/modresorts-1.0.war /config/apps/modresorts-1.0.war
COPY server.xml                /config/server.xml
COPY jvm.options               /config/jvm.options
