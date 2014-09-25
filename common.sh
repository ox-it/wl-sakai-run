# Setup common things for both the pre and post scripts.

[ "$WORKSPACE" ] || WORKSPACE=`pwd`
# We keep this outside the workspace so that if the workspace gets wiped out 
# we can still terminate the process
export CATALINA_PID="/tmp/${JOB_NAME}-catalina.pid"
export CATALINA_OPTS="-server -Xms256m -Xmx1024m -XX:NewSize=192m -XX:MaxNewSize=384m -XX:PermSize=192m -XX:MaxPermSize=384m -Djava.awt.headless=true -Dsun.net.inetaddr.ttl=0 -Dsun.lang.ClassLoader.allowArraySyntax=true -Dlog4j.ignoreTCL=true"

export CATALINA_HOME="$WORKSPACE/target/tomcat/"
export JAVA_OPTS="$JAVA_OPTS -Dsolr.solr.home=$CATALINA_HOME/solr/"
# This sets JAVA_HOME to something sensible
# but I'm not sure we want todo this as then we can't use the value from the
# jenkins job
# export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:bin/javac::")

# If we have a JMX Port set use that:
if [ -n "$JMX_PORT" ] ; then
    export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.rmi.port=$JMX_PORT -Dcom.sun.management.jmxremote.port=$JMX_PORT -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=$(hostname -f)"
fi

