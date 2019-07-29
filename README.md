# vertica-helm-kubernetes
Helm chart and related Kubernetes resources to run Vertica
Currently available:
- vertica-ce: A Helm chart that deploys a single node Vertica instance and creates a port forward to access Vertica.  Run it with `helm install .`  More details on the wiki at https://github.com/bryanherger/vertica-helm-kubernetes/wiki/vertica-ce-quickstart Docker image: https://cloud.docker.com/u/bryanherger/repository/docker/bryanherger/vertica-ce built from source: https://github.com/bryanherger/docker-vertica-1
# TODO
Support multiple nodes, support persistent storage, scale up and scale down, Eon mode... Contributions and pull requests welcome!

