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
  if [ "${CONTENT_KEEP}" != "true" ]; then
    echo Cleaning database
    db=${DB_NAME}
    ( echo "SET foreign_key_checks = 0;"
    mysql $db -e 'show tables' -sN | while read table
    do
      echo "DROP TABLE $table;"
    done) | mysql $db
  else
    # Keep the sakai files.
    if [ -d ${CATALINA_HOME}/sakai/files/ ]; then
      echo Backing up uploaded content
      tar zcf /tmp/${BUILD_TAG}.tgz -C ${CATALINA_HOME}/sakai/files/ .
    fi
  fi
 
fi
