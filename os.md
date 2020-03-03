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

List all users & identities
```
oc get users
oc get identities
```

Configure scheduled import to ImageStream from external repo. Default interval is 15min and can be changed by cluster wide setting `ScheduledImageImportMinimumIntervalSeconds`
```
oc tag --scheduled docker.io/python:3.6.0 python:3.6
```

Manually triggers ImageStream to poll upstream registry
```
oc import-image python:3.6
```

Tag current latest from ImageStream as stable
```
oc tag image:latest image:stable
```

Link secret to to ServiceAccount
```
oc secrets link deployer secret-name --for=pull
```

Get token of ServiceAccount
```
oc sa get-token <sa-name>
```

Login under a ServiceAccount
```
oc login --token $(oc sa get-token deployer)
```

## Minishift

Enable RedHat registry login (minishift vm must be recreated):

```
minishift addons enable redhat-registry-login
minishift stop && minishift start
```

Manually pull an image in Minishift VM
```
minishift ssh
docker login -u <user> https://registry.redhat.io
docker pull registry.redhat.io/amq7/amq-streams-operator:1.3.0
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

Change dimensions of minishift vm (kvm):
```
virsh setmaxmem <vm-name> 12G --config
virsh setmem <vm-name> 12G --config
virsh edit <vm-name>  change <vcpu placement='static'>4</vcpu>
minishift --memory 12GB --cpus 4 start
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


Process template locally with multiple param files
```
oc process --local -f wekan.yaml --ignore-unknown-parameters -o yaml --param-file wekan-test-precedence.env --param-file wekan-test.env
```


Wait for a condition
```
oc wait pod -l strimzi.io/cluster=dev-1 --for=condition=Ready --timeout=60s
```

Wait for Kafka to become ready
```
#!/bin/bash
wait_for_kafka () {
    KAFKA_NAME=$1
    NAMESPACE=$2
    TIMEOUT=$3
    TIME_CONSUMED=0

    while (( `oc get kafka $KAFKA_NAME -n $NAMESPACE -o jsonpath='{.metadata.generation}'` > $(oc get kafka $KAFKA_NAME -n $NAMESPACE -o jsonpath='{.status.observedGeneration}') )); do
        if [ "$TIME_CONSUMED" -gt "$TIMEOUT" ]; then
            echo "ERROR: Timeout of $TIMEOUT seconds waiting for $KAFKA_NAME exceeded..."
            exit 1
        fi
        echo "Waiting for resources of the Kafka cluster '$KAFKA_NAME' in Namespace '$NAMESPACE' to become ready..."
        TIME_CONSUMED=$((TIME_CONSUMED+1))
        sleep 1
    done    
    oc wait kafka kafka --for=condition=Ready --timeout=60s
    echo "Kafka cluster $KAFKA_NAME is reconciled and ready."
}

wait_for_kafka "kafka" "kafka-dev-1" 180
```

Kill specific container in pod
```
oc exec kafka-entity-operator-8577f8b6b7-df2gs -c user-operator -- /bin/bash -c "kill 1"
```

Delete all triggers of a dc
```
oc set triggers dc/nginx --remove-all=true
```

Start job and wait for completion
```
oc run say-hello --image=busybox --replicas=1  --restart=OnFailure --command -- /bin/sh -c "date; echo Hello from the Kubernetes cluster; sleep 10"
oc wait --for=condition=complete job/say-hello --timeout=60s
```

Anti affinity rule. The entries of matchExpressions are anded
```
template:
  pod:
    affinity:
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
            - key: my-first-label
              operator: In
              values:
              - foo
            - key: my-second-label
              operator: In
              values:
              - bar
          topologyKey: "kubernetes.io/hostname"
```
