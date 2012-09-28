# Setup common things for both the pre and post scripts.

[ "$WORKSPACE" ] || WORKSPACE=`pwd`
export CATALINA_PID="$WORKSPACE/target/catalina-buckett.pid"
export CATALINA_OPTS="-server -Xms256m -Xmx1024m -XX:NewSize=192m -XX:MaxNewSize=384m -XX:PermSize=192m -XX:MaxPermSize=384m -Djava.awt.headless=true -Dsun.net.inetaddr.ttl=0 -Dsun.lang.ClassLoader.allowArraySyntax=true"
export CATALINA_HOME="$WORKSPACE/target/tomcat/"
export JAVA_OPTS="$JAVA_OPTS -Dsolr.solr.home=$CATALINA_HOME/solr/"
# This sets JAVA_HOME to something sensible
export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:bin/javac::")
