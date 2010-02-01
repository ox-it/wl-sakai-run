#!/bin/sh
# Script executed before the build

. $WORKSPACE/common.sh
if [ -d $CATALINA_HOME ] ; then
  chmod +x $CATALINA_HOME/bin/*.sh
  $CATALINA_HOME/bin/catalina.sh stop -force
fi
