## Cluster Management

Who has which permissions?
```
oc policy who-can create crd
```

List all users with a specific ClusterRoleBinding
```
oc get clusterrolebindings -o json | jq '.items[] | select(.metadata.name=="cluster-admins") | .userNames'
```

Get all permissions of a specific RoleBinding or ClusterRole
```
oc describe rolebinding admin
oc describe clusterrole admin
```

Create new user, group and assign role to group
```
oc create user bill
oc create identity anypassword:bill
oc adm groups new secret-readers
oc adm groups add-users secret-readers bill
oc adm policy add-role-to-group my-role secret-readers
oc create clusterrole secret-reader --verb get --resource=secret
```

Create new ServiceAccount with assigned role
```
oc create role secret-reader --verb get --resource=secret
oc create sa my-service-account
oc adm policy add-role-to-user secret-reader system:serviceaccount:my-namespace:my-service-account
```

## Minishift

Enable RedHat registry login:

```
minishift addons enable redhat-registry-login
minishift stop && minishift start
```

Configure docker env
```
eval $(minishift docker-env)
```

Adds ClusterRole `cluster-admin` to admin
```
docker exec -it origin /bin/bash
oc --config=/var/lib/origin/openshift.local.config/master/admin.kubeconfig adm policy --as system:admin add-cluster-role-to-user cluster-admin admin
```

## Snippets

Binary S2I

```
oc new-build --name=myproject registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift --binary=true
oc start-build bc/myproject -F --from-file build/libs/app.jar
oc new-app myproject
oc expose svc/myproject
oc get route myproject
```

Create Template from 

```
oc export svc,dc,is --selector app=cp-schema-registry --as-template=schema-registry
```

Single file Mount
```
- mountPath: /tmp/src/log4j.properties
  name: test-volume
  subPath: log4j.properties
...
volumes:
- configMap:
    defaultMode: 420
    name: kafka-kafka-config
  name: test-volume

```
*Not working with Secrets!*
