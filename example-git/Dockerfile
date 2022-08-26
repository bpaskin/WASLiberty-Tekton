
FROM eclipse-temurin:8-jdk-focal

CMD ["gradle"]

ENV GRADLE_HOME /opt/gradle

RUN set -o errexit -o nounset \
    && echo "Adding gradle user and group" \
    && groupadd --system --gid 1000 gradle \
    && useradd --system --gid gradle --uid 1000 --shell /bin/bash --create-home gradle \
    && mkdir /home/gradle/.gradle \
    && chown --recursive gradle:gradle /home/gradle \
    \
    && echo "Symlinking root Gradle cache to gradle Gradle cache" \
    && ln --symbolic /home/gradle/.gradle /root/.gradle

VOLUME /home/gradle/.gradle

WORKDIR /home/gradle

RUN set -o errexit -o nounset \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
        unzip \
        wget \
        \
        bzr \
        git \
        git-lfs \
        mercurial \
        openssh-client \
        subversion \
    && rm --recursive --force /var/lib/apt/lists/* \
    \
    && echo "Testing VCSes" \
    && which bzr \
    && which git \
    && which git-lfs \
    && which hg \
    && which svn

ENV GRADLE_VERSION 4.10.2
ARG GRADLE_DOWNLOAD_SHA256=b49c6da1b2cb67a0caf6c7480630b51c70a11ca2016ff2f555eaeda863143a29
RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Checking download hash" \
    && echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && echo "Testing Gradle installation" \
    && gradle --version
RUN ls /opt/java/openjdk

RUN find /opt/java -name "javac"

COPY cer1.cer /tmp/cer1.cer
COPY cer2.cer /tmp/cer2.cer
COPY cer3.cer /tmp/cer3.cer

RUN keytool -importcert -file /tmp/cer1.cer -keystore /opt/java/openjdk/jre/lib/security/cacerts -storepass changeit -noprompt -alias wstcer1
RUN keytool -importcert -file /tmp/cer2.cer -keystore /opt/java/openjdk/jre/lib/security/cacerts -storepass changeit -noprompt -alias wstcer2
RUN keytool -importcert -file /tmp/cer3.cer -keystore /opt/java/openjdk/jre/lib/security/cacerts -storepass changeit -noprompt -alias wstcer3

RUN ln -s /opt/java/openjdk /opt/java_1.8_64

RUN mkdir /opt/runtimes \
    && echo "hello" >  /tmp/hello.txt \
    && /opt/java/openjdk/bin/jar -cvf /opt/runtimes/j2ee.jar /tmp/hello.txt
