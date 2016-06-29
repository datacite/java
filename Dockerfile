FROM phusion/baseimage:0.9.18
MAINTAINER Martin Fenner "mfenner@datacite.org"

# Set correct environment variables
ENV HOME /home/app
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV CATALINA_HOME /usr/share/tomcat7
ENV CATALINA_BASE /var/lib/tomcat7
ENV CATALINA_PID /var/run/tomcat7.pid
ENV CATALINA_SH /usr/share/tomcat7/bin/catalina.sh
ENV CATALINA_TMPDIR /tmp/tomcat7-tomcat7-tmp
ENV DOCKERIZE_VERSION v0.2.0

# Allow app user to read /etc/container_environment
RUN useradd -d /home/app -m app && \
    usermod -a -G docker_env app

# Use baseimage-docker's init process
CMD ["/sbin/my_init"]

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get update && apt-get install -y wget && \
    apt-get install -yqq software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -yqq oracle-java8-installer && \
    apt-get install -yqq oracle-java8-set-default && \
    apt-get -yqq install tomcat7 maven && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

RUN ln -s /var/lib/tomcat7/common $CATALINA_HOME/common && \
    ln -s /var/lib/tomcat7/server $CATALINA_HOME/server && \
    ln -s /var/lib/tomcat7/shared $CATALINA_HOME/shared && \
    ln -s /etc/tomcat7 $CATALINA_HOME/conf && \
    mkdir $CATALINA_HOME/temp && \
    mkdir -p $CATALINA_TMPDIR && \
    chown -R app:app /usr/share/tomcat7 /var/lib/tomcat7 && \
    chmod -R 755 /usr/share/tomcat7 /var/lib/tomcat7

RUN rm -rf /var/lib/tomcat7/webapps/docs* && \
    rm -rf /var/lib/tomcat7/webapps/examples* && \
    rm -rf /var/lib/tomcat7/webapps/ROOT*

COPY tomcat7 /etc/default/tomcat7

# install dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

VOLUME [ "/var/log/tomcat7/" ]
