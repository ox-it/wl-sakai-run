#!/bin/bash
# Script executed before the build

. $WORKSPACE/common.sh
if [ -d $CATALINA_HOME -a -f $CATALINA_PID ] ; then
  chmod +x $CATALINA_HOME/bin/*.sh
  if $CATALINA_HOME/bin/catalina.sh stop -force ; then
    echo Tomcat stopped
  fi
fi
