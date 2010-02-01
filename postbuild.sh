#!/bin/sh
# Script executed after the build

source common.sh
if [ -d $CATALINA_HOME ] ; then
  $CATALINA_HOME/bin/catalina.sh start
fi
