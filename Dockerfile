FROM phusion/baseimage:0.9.18
MAINTAINER Martin Fenner "mfenner@datacite.org"

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV CATALINA_HOME /usr/share/tomcat7
ENV CATALINA_BASE /var/lib/tomcat7
ENV CATALINA_PID /var/run/tomcat7.pid
ENV CATALINA_SH /usr/share/tomcat7/bin/catalina.sh
ENV CATALINA_TMPDIR /tmp/tomcat7-tomcat7-tmp

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get update && \
    apt-get install -yqq software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -yqq oracle-java8-installer && \
    apt-get install -yqq oracle-java8-set-default && \
    apt-get -yqq install tomcat7 maven && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

RUN mkdir -p $CATALINA_TMPDIR

RUN rm -rf /var/lib/tomcat7/webapps/docs* && \
    rm -rf /var/lib/tomcat7/webapps/examples* && \
    rm -rf /var/lib/tomcat7/webapps/ROOT*

VOLUME [ "/var/log/tomcat7/" ]

WORKDIR /var/lib/tomcat7/webapps/

EXPOSE 8080

ENTRYPOINT [ "/usr/share/tomcat7/bin/catalina.sh" ]
