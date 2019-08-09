#!/bin/bash
sudo docker container rm vertica-ce
sudo docker build -f `ls | grep centos` \
             --build-arg VERTICA_PACKAGE=`ls packages | grep RHEL6` \
             -t bryanherger/vertica-ce:9.2.1-3-k8s .
sudo docker create --name vertica-ce -it -p 15433:5433 bryanherger/vertica-ce:9.2.1-3-k8s
sudo docker start -i vertica-ce
sudo docker container rm vertica-ce
