# Cheatsheet of Java related stuff

#### Check Java compiler version of transitive maven dependencies

Plugin configuration to restrict Java version to 1.7:
```
<build>
 <plugins>
  <plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-enforcer-plugin</artifactId>
    <version>3.0.0-M1</version>
    <executions>
      <execution>
        <id>enforce-bytecode-version</id>
        <goals>
          <goal>enforce</goal>
        </goals>
        <configuration>
          <rules>
            <enforceBytecodeVersion>
              <maxJdkVersion>1.7</maxJdkVersion>
            </enforceBytecodeVersion>
          </rules>
        </configuration>
      </execution>
    </executions>
    <dependencies>
      <dependency>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>extra-enforcer-rules</artifactId>
        <version>1.0-beta-6</version>
      </dependency>
    </dependencies>
  </plugin>
</plugins>
```

Run *mvn validate*:
```
~/projects/github/activemq-artemis/examples/features/sub-modules/artemis-ra-rar(ec63189*) » mvn validate                                                                                                                                                                                         bbuehlmann@bbuehlmann-puzzle
[INFO] Scanning for projects...
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building ActiveMQ Artemis JMS RA 2.4.0
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M1:enforce (enforce-maven) @ artemis-rar ---
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M1:enforce (enforce-java) @ artemis-rar ---
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M1:enforce (enforce-bytecode-version) @ artemis-rar ---
[INFO] Restricted to JDK 1.7 yet io.netty:netty-common:jar:4.1.16.Final:compile contains io/netty/util/internal/shaded/org/jctools/queues/package-info.class targeted to JDK 1.8
[INFO] Restricted to JDK 1.7 yet org.apache.activemq:artemis-service-extensions:jar:2.4.0:compile contains org/apache/activemq/artemis/service/extensions/xa/ActiveMQXAResourceWrapper.class targeted to JDK 1.8
[INFO] Restricted to JDK 1.7 yet org.apache.activemq:artemis-jdbc-store:jar:2.4.0:compile contains org/apache/activemq/artemis/jdbc/store/journal/JDBCJournalImpl$JDBCJournalSync.class targeted to JDK 1.8
[INFO] Restricted to JDK 1.7 yet org.apache.activemq:artemis-native:jar:2.4.0:compile contains org/apache/activemq/artemis/jlibaio/LibaioContext$1.class targeted to JDK 1.8
[INFO] Restricted to JDK 1.7 yet org.apache.activemq:artemis-commons:jar:2.4.0:compile contains org/apache/activemq/artemis/core/buffers/impl/ChannelBufferWrapper.class targeted to JDK 1.8
[INFO] Restricted to JDK 1.7 yet org.apache.activemq:artemis-selector:jar:2.4.0:compile contains org/apache/activemq/artemis/selector/hyphenated/ParseException.class targeted to JDK 1.8
[INFO] Restricted to JDK 1.7 yet org.apache.activemq:artemis-journal:jar:2.4.0:compile contains org/apache/activemq/artemis/core/journal/Journal.class targeted to JDK 1.8
[INFO] Restricted to JDK 1.7 yet org.apache.activemq:artemis-server:jar:2.4.0:compile contains org/apache/activemq/artemis/spi/core/naming/BindingRegistry.class targeted to JDK 1.8
[WARNING] Rule 0: org.apache.maven.plugins.enforcer.EnforceBytecodeVersion failed with message:
Found Banned Dependency: io.netty:netty-common:jar:4.1.16.Final
Found Banned Dependency: org.apache.activemq:artemis-service-extensions:jar:2.4.0
Found Banned Dependency: org.apache.activemq:artemis-jdbc-store:jar:2.4.0
Found Banned Dependency: org.apache.activemq:artemis-native:jar:2.4.0
Found Banned Dependency: org.apache.activemq:artemis-commons:jar:2.4.0
Found Banned Dependency: org.apache.activemq:artemis-selector:jar:2.4.0
Found Banned Dependency: org.apache.activemq:artemis-journal:jar:2.4.0
Found Banned Dependency: org.apache.activemq:artemis-server:jar:2.4.0
Use 'mvn dependency:tree' to locate the source of the banned dependencies.
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 2.157 s
[INFO] Finished at: 2017-11-28T12:35:52+01:00
[INFO] Final Memory: 39M/427M
[INFO] ------------------------------------------------------------------------
```
