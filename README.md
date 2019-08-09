# vertica-helm-kubernetes
Helm chart and related Kubernetes resources to run Vertica
Currently available:
- vertica-ce: A Helm chart that deploys a single node Vertica instance and creates a port forward to access Vertica.  Run it with `helm install .`  More details on the wiki at https://github.com/bryanherger/vertica-helm-kubernetes/wiki/vertica-ce-quickstart Docker image: https://cloud.docker.com/u/bryanherger/repository/docker/bryanherger/vertica-ce built from source in vertica-barebones folder.
- vertica-barebones: the Docker container used by vertica-ce
# TODO
Support multiple nodes, support persistent storage, scale up and scale down, Eon mode... Contributions and pull requests welcome!

