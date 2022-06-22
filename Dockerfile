FROM ibmcom/websphere-traditional:9.0.5.10

COPY PASSWORD /tmp/PASSWORD
COPY appConfig.py /work/config/
COPY app-install.props  /work/config/app-install.props
COPY target/modresorts-1.0.war /work/config/modresorts-1.0.war
RUN /work/configure.sh
