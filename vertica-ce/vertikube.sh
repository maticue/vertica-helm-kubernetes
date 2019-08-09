#!/bin/bash
# vertikube.sh - hopefully the fastest way to stand up a Vertica cluster on Kubernetes!
# this is largely derived from a session transcript that is on the GitHub wiki
# kubectl must be set up before you run this...

# install the chart
helm install -n vertikube .

# edit or comment out this line if you don't want 3 nodes
kubectl scale --replicas 3 deployment/vertikube-vertica-ce

# wait until all IP's are available
ALL_IPS=none
while [[ $ALL_IPS == *"none"* ]]; do
    sleep 5
    ALL_IPS=`kubectl get pods -o wide --namespace default -l "app.kubernetes.io/name=vertica-ce,app.kubernetes.io/instance=vertikube" | awk '{print $6}' | tr '\n' ','`
    ALL_IPS=${ALL_IPS%?}
    ALL_IPS=${ALL_IPS:3}
    echo $ALL_IPS
done

POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=vertica-ce,app.kubernetes.io/instance=vertikube" -o jsonpath="{.items[0].metadata.name}")
kubectl exec $POD_NAME -i -t -- /opt/vertica/sbin/install_vertica --debug --license CE --accept-eula --hosts $ALL_IPS --dba-user-password-disabled --failure-threshold NONE --no-system-configuration --point-to-point
# consider setting a password here depending on your use case!
kubectl exec $POD_NAME -i -t -- su - dbadmin -c "/opt/vertica/bin/admintools -t create_db --skip-fs-checks --hosts $ALL_IPS -d vertikube -c /tmp/catalog -D /tmp/data"
# adjust general pool size to fit in your container request and limit
kubectl exec $POD_NAME -i -t -- /opt/vertica/bin/vsql -U dbadmin -c "ALTER RESOURCE POOL general MAXMEMORYSIZE '3000M';"
kubectl exec $POD_NAME -i -t -- su - dbadmin -c "/opt/vertica/bin/admintools -t stop_db -d vertikube -i"
kubectl exec $POD_NAME -i -t -- su - dbadmin -c "/opt/vertica/bin/admintools -t start_db -d vertikube -i"

