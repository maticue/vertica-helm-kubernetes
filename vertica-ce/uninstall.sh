#!/bin/bash
# vertikube.sh - hopefully the fastest way to stand up a Vertica cluster on Kubernetes!
# this is largely derived from a session transcript that is on the GitHub wiki
# kubectl must be set up before you run this...

K_NAMESPACE=$1
K_VERTICA_NAME=$2

if $(helm ls --namespace {K_NAMESPACE})
then
  # remove instance
  helm delete --purge ${K_VERTICA_NAME} 
  # remove ns
  kubectl delete ns ${K_NAMESPACE}
fi
