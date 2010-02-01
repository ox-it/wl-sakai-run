#!/bin/bash
# Script executed after the build

. common.sh
if [ -d $CATALINA_HOME ] ; then
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
