#!/bin/bash
# Script executed before the build

. common.sh
if [ -d $CATALINA_HOME -a -f $CATALINA_PID ] ; then
  chmod +x $CATALINA_HOME/bin/*.sh
  if $CATALINA_HOME/bin/catalina.sh stop -force ; then
    echo Tomcat stopped
  fi
  
  # Current user needs access to the database
  # -s No boxing -N No column names
  db=test
  (mysql $db -e 'show tables' -sN | while read table
  do
    echo DROP TABLE $table;
  done) | mysql $db
 
fi
