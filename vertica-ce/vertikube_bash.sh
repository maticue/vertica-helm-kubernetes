#!/bin/bash
# vertikube_vsql.sh - quick connect via shell to your Vertica Kubernetes instance.
POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=vertica-ce,app.kubernetes.io/instance=vertikube" -o jsonpath="{.items[0].metadata.name}")
kubectl exec $POD_NAME -i -t -- bash -il

