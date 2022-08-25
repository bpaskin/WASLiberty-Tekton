
FROM gradle:6.9.2-jdk8

RUN ls -al

RUN keytool -importcert -file ca.crt -keystore /opt/java/openjdk/jre/lib/security/cacerts -storepass changeit -noprompt -alias westfield

