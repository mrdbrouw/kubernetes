#!/bin/bash

# find IP address on control network
advertise_ip=$( ifconfig | grep 'inet addr:10.2' | tr -s ' ' | cut -d' ' -f3 | sed 's/addr://' )

# initialize cluster
sudo kubeadm init --apiserver-advertise-address=$advertise_ip --pod-network-cidr=10.244.0.0/16 | sudo tee /kubeadm_init.log

# setup kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# deploy Flannel network driver
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# deploy Dashboard
# kubectl apply -f  /proj/wall2-ilabt-iminds-be/iot-stack/kubernetes-dashboard.yaml

# setup proxy so :8001 is exposed. TODO: make sure to change the address so it listens on local ips only!
# kubectl proxy --address="0.0.0.0"  --accept-hosts '.*' &

# Install helm binary
#(cd / && \
# wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz && \
# tar -zxvf helm-v2.11.0-linux-amd64.tar.gz && \
# mv linux-amd64/helm /usr/local/bin/helm \
#)

# Install helm diff and helmsman
#helm plugin install https://github.com/databus23/helm-diff
#curl -L https://github.com/Praqma/helmsman/releases/download/v1.12.0/helmsman_1.12.0_linux_amd64.tar.gz | tar zx | mv helmsman /usr/bin

# Install helm into the cluster
#helm init --service-account default
#kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
