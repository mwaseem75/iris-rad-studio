# ARG IMAGE=store/intersystems/iris-community:2020.1.0.204.0
# ARG IMAGE=intersystemsdc/iris-community:2020.1.0.209.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.2.0.204.0-zpm
# ARG IMAGE=store/intersystems/iris-community-arm64:2020.3.0.221.0
#Replaced with below image to fix Error: Invalid Community Edition license
ARG IMAGE=intersystemsdc/iris-community:2021.1.0.215.3-zpm
FROM $IMAGE

USER root

WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
COPY irissession.sh /
RUN chmod +x /irissession.sh

# RUN mkdir -p /tmp/deps \
#  && cd /tmp/deps \
#  && wget -q https://pm.community.intersystems.com/packages/zpm/latest/installer -O zpm.xml

USER ${ISC_PACKAGE_MGRUSER}

COPY  Installer.cls .
COPY  src src
COPY module.xml module.xml
SHELL ["/irissession.sh"]

RUN \
  do $SYSTEM.OBJ.Load("/opt/irisapp/src/App/Installer.cls", "ck") \
  set sc = ##class(App.Installer).InstallFromDockerfile()

# bringing the standard shell back
SHELL ["/bin/bash", "-c"]

USER root
RUN chown -R irisuser:irisuser /opt
# RUN chown -R irisuser:irisuser /usr/irissys/csp/forms
