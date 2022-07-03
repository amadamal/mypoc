FROM rhel
RUN useradd -m jboss ; echo jboss: | chpasswd; usermod -a -G wheel jboss
RUN mkdir -p /opt/rh 
ADD jboss-eap-6.1.0.zip /tmp/jboss-eap-6.0.1.zip
WORKDIR /opt/rh
RUN yum install -y unzip
RUN yum install -y java &&\
    yum clean all
RUN unzip /tmp/jboss-eap-6.0.1.zip

ENV JBOSS_HOME /opt/rh/jboss-eap-6.1
RUN $JBOSS_HOME/bin/add-user.sh admin admin@2016 --silent

RUN echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> $JBOSS_HOME/bin/standalone.conf
RUN chown -R jboss:jboss /opt/rh
EXPOSE 8080 9990 9999
ENTRYPOINT $JBOSS_HOME/bin/standalone.sh -c standalone-full-ha.xml

USER jboss
