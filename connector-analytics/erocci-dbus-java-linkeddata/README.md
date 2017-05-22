mvn exec:java -Dexec.mainClass="org.ow2.erocci.backend.BackendDBusService"

then :
cd erocci
vi config/dbus-java.config
./start.sh -c config/dbus-java.config
