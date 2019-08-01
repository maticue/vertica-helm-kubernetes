#!/bin/bash
# vertikube_vsql.sh - quick connect to your Vertica Kubernetes instance.  You may be prompted for a password if you set one.
POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=vertica-ce,app.kubernetes.io/instance=vertikube" -o jsonpath="{.items[0].metadata.name}")
kubectl exec $POD_NAME -i -t -- /opt/vertica/bin/vsql -U dbadmin

