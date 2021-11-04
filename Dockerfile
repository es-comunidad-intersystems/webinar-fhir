ARG IMAGE=store/intersystems/irishealth-community:2021.1.0.215.3
FROM $IMAGE

USER root
COPY irissession.sh /
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /irissession.sh
RUN chmod u+x /irissession.sh

USER irisowner

# download zpm package manager
RUN mkdir -p /tmp/deps \
 && cd /tmp/deps \
 && wget -q https://pm.community.intersystems.com/packages/zpm/latest/installer -O zpm.xml

SHELL ["/irissession.sh"]
RUN \
  # install zpm + webterminal
  do $system.OBJ.Load("/tmp/deps/zpm.xml", "ck") \
  zpm "install webterminal" \
  set sc = 1
  
# bringing the standard shell back
SHELL ["/bin/bash", "-c"]
CMD [ "-l", "/usr/irissys/mgr/messages.log" ]