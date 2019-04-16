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
oc describe clusterrole strimzi-admin
```

## Minishift

Configure docker env
```
eval $(minishift docker-env)
```

Adds ClusterRole `cluster-admin` to admin
```
docker exec -it origin /bin/bash
oc --config=/var/lib/origin/openshift.local.config/master/admin.kubeconfig adm policy --as system:admin add-cluster-role-to-user cluster-admin admin
```

## Binary S2I

```
oc new-build --name=myproject redhat-openjdk18-openshift --binary=true
oc start-build bc/myproject -F --from-file build/libs/app.jar
oc new-app myproject
oc expose svc/myproject
oc get route myproject
```
