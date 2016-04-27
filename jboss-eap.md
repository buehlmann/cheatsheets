# JBoss EAP 6.4 Cheatsheet and link collection

#### Using a different version of the JSF implementation
Using Mojarra 2.1.19 instead of 2.1.28 on EAP 6.4.5

1. Install the API and implementation of the needed JSF version: `[standalone@localhost:9999 /] deploy /tmp/mojarra-2.1.19.cli`
2. Verify the installation installation:
 * `$JBOSS_HOME/modules/com/sun/jsf-impl/mojarra-2.1.19: module.xml, jsf-impl-2.1.19-redhat-1.jar`
 * `$JBOSS_HOME/modules/javax/faces/api/mojarra-2.1.19: module.xml, jboss-jsf-api_2.1_spec-2.1.19.1.Final-redhat-1.jar`
 * `$JBOSS_HOME/modules/org/jboss/as/jsf-injection/mojarra-2.1.19: module.xml`
3. Reboot the JBoss Application Server
4. Optional: Change the default JSF Implementation to the new installed version: `[standalone@localhost:9999 /] /subsystem=jsf/:write-attribute(name=default-jsf-impl-slot,value=mojarra-2.1.19)`
5. Lets reference weld to the new installed version of JSF: Define in the dependencies to the JSF API the previous installed slot by adding `slot="mojarra-2.1.19"` to `<module name="javax.faces.api"/>` in the following module.xml files of weld:
 * `$JBOSS_HOME/modules/system/layers/base/org/jboss/as/weld/main/module.xml`
 * `$JBOSS_HOME/modules/system/layers/base/org/jboss/weld/core/main/module.xml`
 * `$JBOSS_HOME/modules/system/layers/base/.overlays/layer-base-jboss-eap-6.4.5.CP/org/jboss/weld/core/main/module.xml` (only used if the as is patched)
 * `$JBOSS_HOME/modules/system/layers/base/.overlays/layer-base-jboss-eap-6.4.5.CP/org/jboss/as/weld/main/module.xml` (only used if the as is patched)
6. Configure the webapplications to reference the installed Mojarra version in web.xml:
```xml
<context-param>
  <param-name>org.jboss.jbossfaces.JSF_CONFIG_NAME</param-name>
  <param-value>mojarra-2.1.19</param-value>
</context-param>
```
_Restrictions_  
* It's not possible to deploy multiple webapps to the same JBoss instance with different JSF implementation versions
* The module.xml files of weld have to be updated manually in the .overlays directory after patching the applicationserver

_References_  
* https://access.redhat.com/solutions/793963
* https://access.redhat.com/solutions/637783
* https://developer.jboss.org/wiki/DesignOfAS7Multi-JSFFeature

#### Using placeholders in Spec files like persistence.xml
standalone.xml  
```xml
<spec-descriptor-property-replacement>true</spec-descriptor-property-replacement>
```
persistence.xml  
```xml
<property name="hibernate.search.default.indexBase" value="${lucene.indexBase}"/>
````

#### Example datasource configuration with background validation and new connection query
```xml
<subsystem xmlns="urn:jboss:domain:datasources:1.1">
	<datasources>
		<datasource jta="true" jndi-name="java:/jdbc/foo" pool-name="FooDS" enabled="true" use-ccm="false">
			<connection-url></connection-url>
			<driver>ojdbc6.jar</driver>
			<new-connection-sql>alter session set CURRENT_SCHEMA = foo_schema</new-connection-sql>
			<security>
				<user-name>foo</user-name>
				<password>bar</password>
			</security>
			<validation>
				<check-valid-connection-sql>select * from dual</check-valid-connection-sql>
				<background-validation>true</background-validation>
				<background-validation-millis>10000</background-validation-millis>
			</validation>
			<statement>
				<prepared-statement-cache-size>0</prepared-statement-cache-size>
				<share-prepared-statements>false</share-prepared-statements>
			</statement>
		</datasource>
		<drivers>
			<driver name="ojdbc6.jar" module="com.oracle.ojdbc6"/>
		</drivers>
	</datasources>
</subsystem>
````

#### Securing Webapplication by simple, filebased Security Domain with hased passwords
JBoss configuration
```xml
<security-domain name="domain-application-1" cache-type="default">
    <authentication>
        <login-module code="org.jboss.security.auth.spi.UsersRolesLoginModule" flag="required">
            <module-option name="usersProperties" value="file:${jboss.server.config.dir}/application1-users.properties"/>
            <module-option name="rolesProperties" value="file:${jboss.server.config.dir}/application1-roles.properties"/>
            <module-option name="hashUserPassword" value="true"/>
            <module-option name="hashAlgorithm" value="SHA-256"/>
            <module-option name="hashEncoding" value="base64"/>
        </login-module>
    </authentication>
</security-domain>
```

web.xml
```xml
  <security-constraint>
    <web-resource-collection>
      <web-resource-name>SuperUser Area</web-resource-name>
      <url-pattern>/protected</url-pattern>
    </web-resource-collection>
    <auth-constraint>
      <role-name>SuperUser</role-name>
    </auth-constraint>
  </security-constraint>
  
  <security-role>
    <role-name>SuperUser</role-name>
  </security-role>
  
  <login-config>
    <auth-method>BASIC</auth-method>
  </login-config>
```

jboss-web.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<jboss-web>
    <context-root>/counter</context-root>
    <security-domain>domain-application-1</security-domain>
</jboss-web>
```

Generate password hash on console  
`echo -n "my-secret" | openssl dgst -sha256 -binary | openssl base64`  
GG73bp1qcj7LVw1NnCh0h9AB5dNfftSjEzUKQHlQMY4=

application1-users.properties  
`user=ZwCGnI/3SA40pwpwiwKHANuqOgM7VlK5A6/on0mjFFY=`

application1-roles.properties  
`user=PowerUser`

#### Referencing a deployed JDBC driver in Datasource
To be able to deploy a JDBC Driver the JAR must contains the file `META-INF/services/java.sql.Driver` with the fully qualified Driver class(es) (JDBC4 compliant driver).  
The driver will be referenced by the name of the deployment: `<driver>postgresql-9.1.jar</driver>`

#### Proxying the Management Console by mod_proxy
```xml
<VirtualHost *:80>
    ServerName application1.foo.bar
    ProxyPreserveHost On
    ProxyPass "/console" "http://127.0.0.1:9990/console"
    ProxyPassReverse "/console" "http://127.0.0.1:9990/console"
    ProxyPass "/management" "http://127.0.0.1:9990/management"
    ProxyPassReverse "/management" "http://127.0.0.1:9990/management"
</VirtualHost>
```

#### How to use the password Vault feature
The password Vault feature of JBoss lets you use encrypted strings in configuration files (e.g. passwords of the datasource).  

1. Creating a Java Keystore which contains the encrypted passwords:
`keytool -genkey -alias vault -keyalg RSA -keysize 2048 -keystore ~/vault.keystore`
2. Using the `EAP_HOME/bin/vault.sh` script to open a connection to the generated keystore:
```
Please enter a Digit::   0: Start Interactive Session  1: Remove Interactive Session  2: Exit
0
Starting an interactive session
Enter directory to store encrypted files:/home/bbuehlmann/              
Enter Keystore URL:/home/bbuehlmann/vault.keystore
Enter Keystore password: 
Enter Keystore password again: 
Values match
Enter 8 character salt:11223344
Enter iteration count as a number (Eg: 44):59
Enter Keystore Alias:vault
Initializing Vault
Apr 27, 2016 1:38:04 PM org.picketbox.plugins.vault.PicketBoxSecurityVault init
INFO: PBOX000361: Default Security Vault Implementation Initialized and Ready
Vault Configuration in AS7 config file:
********************************************
...
</extensions>
<vault>
  <vault-option name="KEYSTORE_URL" value="/home/bbuehlmann/vault.keystore"/>
  <vault-option name="KEYSTORE_PASSWORD" value="MASK-2cXrUWYGuz9LVmDinhmTfZ"/>
  <vault-option name="KEYSTORE_ALIAS" value="vault"/>
  <vault-option name="SALT" value="11223344"/>
  <vault-option name="ITERATION_COUNT" value="59"/>
  <vault-option name="ENC_FILE_DIR" value="/home/bbuehlmann/"/>
</vault><management> ...
********************************************
Vault is initialized and ready for use
Handshake with Vault complete
```
3. Copying the generated snippet to the standalone.xml or on each host.xml in domain mode.
4. Adding passwords to the vault
```
Please enter a Digit::   0: Store a secured attribute  1: Check whether a secured attribute exists  2: Exit
0
Task: Store a secured attribute
Please enter secured attribute value (such as password): 
Please enter secured attribute value (such as password) again: 
Values match
Enter Vault Block:DataSource 
Enter Attribute Name:password
Secured attribute value has been stored in vault. 
Please make note of the following:
********************************************
Vault Block:DataSource
Attribute Name:password
Configuration should be done as follows:
VAULT::DataSource::password::1
********************************************
```
5. Using the encrypted password in the JBoss configuration:
```
<security>
  <user-name>admin</user-name>
  <password>${VAULT::DataSource::password::1}</password>
</security>
```

#### Transaction Logs
The TX-Logs are located by default under `$JBOSS_HOME/[domain|standalone]/data/tx-object-store/ShadowNoFileLockStore/defaultStore/StateManager/BasicAction/TwoPhaseCoordinator/AtomicAction/`

#### Start the CLI with UI
`jboss-cli.sh --gui`

#### JBoss EAP 6.x Management Model
http://wildscribe.github.io/JBoss%20EAP/6.4.0/subsystem/security/security-domain/authentication/classic/index.html

#### Provided Component Versions in JBoss EAP 6.x
https://access.redhat.com/articles/112673

#### List of all included modules in EAP 6.x with their support levels
https://access.redhat.com/articles/1122333

#### List LoginModules in EAP 6
https://access.redhat.com/documentation/en-US/JBoss_Enterprise_Application_Platform/6.4/html/Security_Guide/chap-Login_Modules.html

#### How to inspect the Classpath of JBoss EAP 6
Static Modules are exposed by MBean "jboss.modules:type=ModuleLoader,name=LocalModuleLoader-2"  
Dynamic Modules (aka deployment artifacts) are exposed by MBean "jboss.modules:type=ModuleLoader,name=ServiceModuleLoader-3"  
Using JConsole to access the JMX Beans exposed by JBoss.  
https://access.redhat.com/solutions/209373

#### List of supported Environments for EAP 6
https://access.redhat.com/articles/111663

#### List of all implicit Dependencies in EAP 6
https://access.redhat.com/documentation/en-US/JBoss_Enterprise_Application_Platform/6.4/html/Development_Guide/sect-Reference1.html#Implicit_Module_Dependencies
