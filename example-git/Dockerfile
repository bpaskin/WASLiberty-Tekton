
FROM gradle:latest

RUN ls -al

RUN keytool -importcert -file ca.crt -keystore /opt/java/openjdk/jre/lib/security/cacerts -storepass changeit -noprompt -alias westfield

