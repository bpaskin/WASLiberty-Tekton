
FROM docker.io/gradle:6.9.2-jdk8

RUN ls -alR

RUN ls -alR /tmp

RUN keytool -importcert -file /tmp/ca.crt -keystore /opt/java/openjdk/jre/lib/security/cacerts -storepass changeit -noprompt -alias westfield

