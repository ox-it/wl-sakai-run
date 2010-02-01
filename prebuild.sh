#!/bin/sh
# Script executed before the build

source $WORKSPACE/common.sh
if [ -d $CATALINA_HOME ] ; then
  $CATALINA_HOME/bin/catalina.sh stop --force
fi
