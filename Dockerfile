ARG IMAGE=intersystemsdc/irishealth-community:2022.1.0.209.0-zpm
FROM $IMAGE

USER root
COPY irissession.sh /
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /irissession.sh
RUN chmod u+x /irissession.sh

USER irisowner

SHELL ["/irissession.sh"]
RUN \
  # install zpm + webterminal
  zpm "install webterminal" \
  zn "HSLIB" \
  do ##class(HS.HC.Util.Installer).InstallFoundation("FHIRNamespace") \
  set sc = 1
  
# bringing the standard shell back
SHELL ["/bin/bash", "-c"]
CMD [ "-l", "/usr/irissys/mgr/messages.log" ]