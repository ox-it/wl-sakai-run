# Setup common things for both the pre and post scripts.

export CATALINA_PID="$WORKSPACE/target/catalina-buckett.pid"
export CATALINA_OPTS="-server -Xms256m -Xmx1024m -XX:NewSize=192m -XX:MaxNewSize=384m -XX:PermSize=192m -XX:MaxPermSize=256m -Djava.awt.headless=true -Dsun.net.inetaddr.ttl=0 -Dsun.lang.ClassLoader.allowArraySyntax=true"
export CATALINA_HOME="$WORKSPACE/target/tomcat/"
