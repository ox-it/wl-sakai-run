#!/bin/sh
# Script executed after the build

. $WORKSPACE/common.sh
if [ -d $CATALINA_HOME ] ; then
  chmod +x $CATALINA_HOME/bin/*.sh
  # http://issues.hudson-ci.org/browse/HUDSON-2729
  BUILD_ID=dontKillMe $CATALINA_HOME/bin/catalina.sh start
  mkfifo $WORKSPACE/target/log-fifo
  tail -f $WORKSPACE/target/tomcat/logs/catalina.out > $WORKSPACE/target/log-fifo &
  tail_pid=$!
  if tee $WORKSPACE/target/log-fifo | grep -q "Server startup in " ; then
    echo yey
  fi
  kill $tail_pid
  wait $tail_pid
fi
