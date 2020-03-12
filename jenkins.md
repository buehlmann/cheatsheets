# Jenkins snippets

#### Decrypting password
- read password from web form
- Goto https://jenkins.company.org/script
- println(hudson.util.Secret.fromString('{AQAAABAAAAAQeQHLaAqLz0U1e1ewIb284bjjD/B0jieyjdnjMlNQM6U=}'))

#### List all buildjob names
```
Jenkins.instance.getAllItems(AbstractItem.class).each {
  println(it.fullName)
};
```

#### Cancel zombie build job
```
Jenkins.instance.getItemByFullName("build/build-integration-artefact-build")
                .getBuildByNumber(110)
                .finish(
                        hudson.model.Result.ABORTED,
                        new java.io.IOException("Aborting build")
                );
```

#### Exposing credentials selected by user as build parameter**
```
pipeline {
  parameters {
    // exposes only the id of the credentials
    credentials(credentialType: 'com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl', defaultValue: 'jboss-deployment-test', description: 'Credentials used to deploy the application to the JBoss Application Server', name: 'DEPLOY_CREDENTIALS_ID', required: true)
  }
  environment {
    // exposing user and password to the env, looked up by exposed credentials id
    // accessisble by DEPLOY_CREDENTIALS_USR and DEPLOY_CREDENTIALS_PSW
    DEPLOY_CREDENTIALS = credentials("${params.DEPLOY_CREDENTIALS_ID}")
  }
}
```

#### Choice parameters
```
pipeline {
  parameters {
    choice(name: 'DEPLOY_SERVER_ADDRESS', choices: 'test.foo.bar\nint.foo.bar\nprod.foo.bar', description: 'test.foo.bar: Test environment\nint.foo.bar: Integration environment')
  }
}
```
Choice parameters must be defined as a new-line separated String because of https://issues.jenkins-ci.org/browse/JENKINS-40358.


#### Print oc Result/Selector

```
def result = openshift.apply(replaceSecretsFromVault(readFile(file: "mongodb.yaml")), "--dry-run", "-l", "app=mongodb")
// The name of the operation performed (i.e. "delete")
echo "Overall status: ${result.operation}"

// The number of sub-actions run
echo "Overall status: ${result.status}"

// First OpenShift command which was executed
echo "Actions performed: ${result.actions[0].cmd}"

// Additional command reference information
echo "Reference information: ${result.actions[0].reference}"

// Aggregate output from all sub-actions
echo "Operation output: ${result.out}"        
```
