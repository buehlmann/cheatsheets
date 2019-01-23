# Cluster Management

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

# Project management
```
oc project <bla>
```
