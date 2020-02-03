## Decrypting password
- read password from web form
- Goto https://jenkins.company.org/script
- println(hudson.util.Secret.fromString('{AQAAABAAAAAQeQHLaAqLz0U1e1ewIb284bjjD/B0jieyjdnjMlNQM6U=}'))

## List all buildjob names
```
Jenkins.instance.getAllItems(AbstractItem.class).each {
  println(it.fullName)
};
```

## Cancel zombie build job
```
Jenkins.instance.getItemByFullName("build/build-integration-artefact-build")
                .getBuildByNumber(110)
                .finish(
                        hudson.model.Result.ABORTED,
                        new java.io.IOException("Aborting build")
                );
```
