# vertica-helm-kubernetes
Helm chart and related Kubernetes resources to run Vertica

Currently available:

**vertica-ce:** A Helm chart that deploys a three-node Vertica instance.  Configure helm and kubectl, clone the repo, cd vertica-ce, edit `./vertikube.sh` to set some options, like a database password and node count; the run the script.  `vertikube_vsql.sh` connects and runs the vsql command line SQL tool.
- More details on the wiki at https://github.com/bryanherger/vertica-helm-kubernetes/wiki/vertica-ce-quickstart 
- Uses Docker image: https://cloud.docker.com/u/bryanherger/repository/docker/bryanherger/vertica-ce built from source: https://github.com/bryanherger/docker-vertica-1
# TODO
Support multiple nodes, support persistent storage, scale up and scale down, Eon mode... Contributions and pull requests welcome!

