# Cluster Management

Who has which permissions?
```
$ oc policy who-can create crd
```

List all users with a specific ClusterRoleBinding
```
$ oc get clusterrolebindings -o json | jq '.items[] | select(.metadata.name=="cluster-admins") | .userNames'
```

# Project management
```
$ oc project <bla>
```
