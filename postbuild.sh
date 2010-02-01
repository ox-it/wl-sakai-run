#!/bin/sh
# Script executed after the build

. common.sh
if [ -d $CATALINA_HOME ] ; then
  $CATALINA_HOME/bin/catalina.sh start
fi
