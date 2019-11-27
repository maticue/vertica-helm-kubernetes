#!/bin/bash
# vertikube.sh - hopefully the fastest way to stand up a Vertica cluster on Kubernetes!
# this is largely derived from a session transcript that is on the GitHub wiki
# kubectl must be set up before you run this...

K_NAMESPACE=$1
K_VERTICA_NAME=$2
VERTICA_DB_NAME=$3

# ensure pvc
if [[ -f ./pvc-ceph-client-key.yaml ]]
then
  kubectl create ns ${K_NAMESPACE}
  kubectl -n ${K_NAMESPACE} apply -f pvc-ceph-client-key.yaml
fi

# install the chart
helm install --namespace ${K_NAMESPACE} -n ${K_VERTICA_NAME} .

# edit or comment out this line if you don't want 3 nodes
#kubectl --namespace ${K_NAMESPACE} scale --replicas 3 deployment/${K_VERTICA_NAME}-vertica-ce

# wait until all IP's are available
ALL_IPS=none
while [[ $ALL_IPS == *"none"* ]]; do
    sleep 5
    ALL_IPS=`kubectl --namespace ${K_NAMESPACE} get pods -o wide -l "app.kubernetes.io/name=vertica-ce,app.kubernetes.io/instance=${K_VERTICA_NAME}" | awk '{print $6}' | tr '\n' ','`
    ALL_IPS=${ALL_IPS%?}
    ALL_IPS=${ALL_IPS:3}
    echo $ALL_IPS
done

POD_NAME=$(kubectl --namespace ${K_NAMESPACE} get pods -l "app.kubernetes.io/name=vertica-ce,app.kubernetes.io/instance=${K_VERTICA_NAME}" -o jsonpath="{.items[0].metadata.name}")
PODS_NAMES=$(kubectl --namespace ${K_NAMESPACE} get pods -l "app.kubernetes.io/name=vertica-ce,app.kubernetes.io/instance=${K_VERTICA_NAME}" -o jsonpath="{.items..metadata.name}")
for pod in ${PODS_NAMES}
do
  kubectl --namespace ${K_NAMESPACE} exec ${pod} -i -t -- chown dbadmin /tmp/catalog /tmp/data
done
kubectl --namespace ${K_NAMESPACE} exec $POD_NAME -i -t -- /opt/vertica/sbin/install_vertica --debug --license CE --accept-eula --hosts $ALL_IPS --dba-user-password-disabled --failure-threshold NONE --no-system-configuration --point-to-point
# consider setting a password here depending on your use case!
kubectl --namespace ${K_NAMESPACE} exec $POD_NAME -i -t -- su - dbadmin -c "/opt/vertica/bin/admintools -t create_db --skip-fs-checks --hosts $ALL_IPS -d ${VERTICA_DB_NAME} -c /tmp/catalog -D /tmp/data"
# adjust general pool size to fit in your container request and limit
kubectl --namespace ${K_NAMESPACE} exec $POD_NAME -i -t -- /opt/vertica/bin/vsql -U dbadmin -c "ALTER RESOURCE POOL general MAXMEMORYSIZE '3000M';"
kubectl --namespace ${K_NAMESPACE} exec $POD_NAME -i -t -- su - dbadmin -c "/opt/vertica/bin/admintools -t stop_db -d ${VERTICA_DB_NAME} -i"
kubectl --namespace ${K_NAMESPACE} exec $POD_NAME -i -t -- su - dbadmin -c "/opt/vertica/bin/admintools -t start_db -d ${VERTICA_DB_NAME} -i"

