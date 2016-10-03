FROM ubuntu:14.04

RUN apt-get update

# Add oracle java 8 repository
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN apt-get install -y oracle-java8-installer maven wget
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/oracle-jdk8-installer

# Install Maven, wget
#RUN apt-get -y install maven wget

#RUN wget -O /tmp/tomcat7.tar.gz http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.69/bin/apache-tomcat-7.0.69.tar.gz
#RUN (cd /opt && tar zxf /tmp/tomcat7.tar.gz)
#RUN (mv /opt/apache-tomcat* /opt/tomcat)
#COPY file/tomcat7/tomcat-users.xml /opt/tomcat/conf/

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV COMPUTERNAME nikolai-N53SM

# Install Node, bower, grunt
RUN apt-get update
RUN apt-get install -y nodejs npm git
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

RUN npm install -g grunt-cli

RUN npm install -g bower
RUN echo '{ "allow_root": true }' > /root/.bowerrc

COPY . /app
WORKDIR /app

RUN mvn clean install

RUN mkdir -p /opt/tomcat/webapps/

RUN ls -l target/

#RUN unzip ./root/target/wars.zip -d /opt/tomcat/webapps/

RUN cp target/springmvc-helloworld.war /opt/tomcat/webapps/

RUN ls -l /opt/tomcat/webapps/