#!/bin/bash
# Script executed after the build

. common.sh
if [ -d $CATALINA_HOME ] ; then
  mkdir -p target/tomcat/sakai/

  # Grab config from svn
  svn export https://svn.oucs.ox.ac.uk/projects/vle/deployment/debian/sakai/config/trunk/sakai.properties target/tomcat/sakai/sakai.properties
  svn export https://svn.oucs.ox.ac.uk/projects/vle/sakai/config/trunk/local.properties target/tomcat/sakai/local.properties
  svn export https://svn.oucs.ox.ac.uk/projects/vle/sakai/config/trunk/log4j.properties target/tomcat/common/classes/log4j.properties
  svn export --force https://svn.oucs.ox.ac.uk/projects/vle/deployment/solr-config target/tomcat/solr
  sed -i "s/DB_NAME/${DB_NAME}/" target/tomcat/sakai/local.properties
  sed -i "s|SEARCH_SOLR_URL|${SEARCH_SOLR_URL}|" target/tomcat/sakai/local.properties
  sed -i "s/TURNITIN_AID/${TURNITIN_AID:-69293}/" target/tomcat/sakai/local.properties
  sed -i "s/TURNITIN_SECRET/${TURNITIN_SECRET:-OUCSsKey}/" target/tomcat/sakai/local.properties
  sed -i "s|TURNITIN_API_URL|${TURNITIN_API_URL:-'https://sandbox.turnitin.com/api.asp'}|" target/tomcat/sakai/local.properties
  sed -i "s|SENTRY_DSN|${SENTRY_DSN}|" target/tomcat/common/classes/log4j.properties

  # Show the build version that we're running.
  echo version.service=$BUILD_TAG >> target/tomcat/sakai/local.properties

  # Copy any archived files back
  if [ -f /tmp/${BUILD_TAG}.tgz ]; then
    mkdir -p ${CATALINA_HOME}/sakai/files/
    tar -zxf /tmp/${BUILD_TAG}.tgz -C ${CATALINA_HOME}/sakai/files/
    # Clean up the file we copied to /tmp
    rm /tmp/${BUILD_TAG}.tgz
  fi

  # Remove existing tomcat webapps except solr
  find target/tomcat/webapps -type d -maxdepth 1 -mindepth 1 -not -name solr | xargs rm -rf 
  # Fix the startup scripts
  chmod +x $CATALINA_HOME/bin/*.sh

  # Start tomcat (with or without debug mode enabled)
  # http://issues.hudson-ci.org/browse/HUDSON-2729
  if [ -z $JPDA_PORT ] ; then
    BUILD_ID=dontKillMe $CATALINA_HOME/bin/catalina.sh start
  else
    export JPDA_ADDRESS="127.0.0.1:${JPDA_PORT}"
    BUILD_ID=dontKillMe $CATALINA_HOME/bin/catalina.sh jpda start
  fi

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

  sleep 5

  # Most builds don't define a HTTP port.
  # So take the HTTPS PORT and attempt to switch to HTTP.
  if [ -z "${HTTP_PORT}" ]; then
    HTTP_PORT=$(echo $HTTPS_PORT| sed 's/443/080/')
  fi

  # See if we can connect
  curl -s -f -m 10 -o /dev/null http://localhost:${HTTP_PORT}/portal/
  if [ $? -ne 0 ]; then
    echo "Can't connect to Tomcat" && exit 1
  fi

fi
