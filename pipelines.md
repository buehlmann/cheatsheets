Jenkins Pipelines Snippets
==========================

**Exposing credentials selected by user as build parameter**
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

**Choice parameters**
```
pipeline {
  parameters {
    choice(name: 'DEPLOY_SERVER_ADDRESS', choices: 'test.foo.bar\nint.foo.bar\nprod.foo.bar', description: 'test.foo.bar: Test environment\nint.foo.bar: Integration environment')
  }
}
```
