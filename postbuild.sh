#!/bin/bash
# Script executed after the build

. common.sh
if [ -d $CATALINA_HOME ] ; then
  mkdir -p target/tomcat/sakai/

  # Grab config from svn
  svn export https://svn.oucs.ox.ac.uk/projects/vle/deployment/debian/sakai/config/trunk/sakai.properties target/tomcat/sakai/sakai.properties
  svn export https://svn.oucs.ox.ac.uk/projects/vle/sakai/config/trunk/local.properties target/tomcat/sakai/local.properties
  sed -i "s/DB_NAME/${DB_NAME}/" target/tomcat/sakai/local.properties
  # Show the build version that we're running.
  echo version.service=$BUILD_TAG >> target/tomcat/sakai/local.properties

  # Remove existing tomcat webapps
  find target/tomcat/webapps -type d -maxdepth 1 -mindepth 1 | xargs rm -rf 
  # Fix the startup scripts
  chmod +x $CATALINA_HOME/bin/*.sh
  # http://issues.hudson-ci.org/browse/HUDSON-2729
  BUILD_ID=dontKillMe $CATALINA_HOME/bin/catalina.sh start
  mkfifo target/log-fifo
  tail -f target/tomcat/logs/catalina.out | tee  target/log-fifo &
  if grep -q "Server startup in " < target/log-fifo ; then
    echo Found startup message
  fi
  # If this happens too quickly then the background job won't be up and running yet.
  tail_pid=`jobs -p %1`
  echo $tail_pid
  kill $tail_pid
  wait $tail_pid
fi
