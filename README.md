
# vespa-k8s-cluster

This repo is a small setup for running a test vespa cluster on kubernetes with [kind](https://kind.sigs.k8s.io/)
for testing slightly more complex Vespa cluster setup.

It's main purpose is to serve as a test cluster for the [vscode-vespa plugin](https://github.com/pehrs/vscode-vespa).


## Requirements

- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) 
- (optional) [k9s](https://k9scli.io/topics/install/) - Good tool for managing your K8s cluster
- (optional) [vscode-vespa](https://github.com/pehrs/vscode-vespa) - Vscode plugin to run Vespa YQL queries against your vespa clusters.

## Create the k8s cluster

The [kind-config.yaml](kind-config.yaml) sets up 5 node cluster with one controller and 4 worker nodes.

```shell
K8S_NAME="vespa-test-cluster"
# If cluster already exist just delet it :-)
kind delete cluster --name "${K8S_NAME}"
kind create cluster \
    --name "${K8S_NAME}" \
    --config kind-config.yaml 
```

## Deploy and start the Vespa Cluster

```shell
kubectl -f k8s/
```

### forward ports needed

The [vscode-vespa plugin](https://github.com/pehrs/vscode-vespa) needs to access the 19071, 19050 and 8080 ports of the vespa config nodes.

```shell
./k8s-forward-ports.sh
```

### Delete and cleanup

```shell
kubectl delete -f k8s/

# Get the PVCs and delete them as they are persisted across K8s restarts.
kubectl get pvc
kubectl delete pvc ...
```

# Deploy vespa application

```shell
cd /path/to/the/vespa-application

# Creates target/application.zip
mvn -DskipTests=true package

# Deploy the application
curl --header Content-Type:application/zip --data-binary @target/application.zip \
  localhost:19071/application/v2/tenant/default/prepareandactivate
```
