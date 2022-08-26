
FROM docker.io/gradle:6.9.2-jdk8

COPY cer1.cer /tmp/cer1.cer
COPY cer2.cer /tmp/cer2.cer
COPY cer3.cer /tmp/cer3.cer

RUN keytool -importcert -file /tmp/cer1.cer -keystore /opt/java/openjdk/jre/lib/security/cacerts -storepass changeit -noprompt -alias wstcer1
RUN keytool -importcert -file /tmp/cer2.cer -keystore /opt/java/openjdk/jre/lib/security/cacerts -storepass changeit -noprompt -alias wstcer2
RUN keytool -importcert -file /tmp/cer3.cer -keystore /opt/java/openjdk/jre/lib/security/cacerts -storepass changeit -noprompt -alias wstcer3

RUN ln -s /opt/java/openjdk /opt/java_1.8_64
