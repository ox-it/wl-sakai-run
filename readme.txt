This small project is to support automatically deployed copies of Sakai with jenkins.

The project should be added as a maven build as this allows upstream dependencies to automatically kickoff the build. The prebuild.sh should be run before the build is started and the postbuild.sh should be run after the build has complete.

The deployed copy of Tomcat is designed to be run behind Apache so that WebAuth works.

The build supports the following configuration parameter set through enviormental variables.

SHUTDOWN_PORT - The port on which tomcat listens for shutdown commands.
AJP_PORT - The port on which tomcat listens for AJP requests.
HTTPS_PORT - The port on which HTTPS requests are handled.
DB_NAME - The name of the MySQL database which should be used.
JPDA_PORT - The port in which JDPA debugger is started.
CONTENT_KEEP - If true then we don't clean the database and attempt to keep the uploaded files.
SEARCH_SOLR_URL - Solr url to enable search with Solr
TURNITIN_AID - Turnitin account
TURNITIN_SECRET - Turnitin password
TURNITIN_API_URL - Turnitin url
SENTRY_DSN - URL used to send information to a sentry instance
