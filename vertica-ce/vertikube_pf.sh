#!/bin/bash
# vertikube_pf.sh - vsql port forward to your Vertica Kubernetes instance.  Connect a client to localhost:35433 (or change below)
POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=vertica-ce,app.kubernetes.io/instance=vertikube" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 35433:5433

