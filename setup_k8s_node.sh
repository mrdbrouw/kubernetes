#!/bin/bash

# Allow internet
wget -O - -q https://www.wall2.ilabt.iminds.be/enable-nat.sh | sudo bash

# Disable swap
swapoff -a

# Load rbd kernel driver (rados block device)
modprobe rbd

if [[ ! -f "/iot_stack_ready" ]]; then
    sudo apt-get update

    # install docker requirements
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

    # install docker
    sudo apt-get update
    sudo apt-get install -y docker-ce

    # remove apparmor
    sudo invoke-rc.d apparmor stop
    sudo update-rc.d -f apparmor remove

sudo su <<EOF
    # make sure the machine id is unique across machines
    sudo cat /proc/sys/kernel/random/uuid | sudo sed "s/-//g" > /etc/machine-id
EOF

    # install kubernetes tools
sudo su <<KUBEEOF

    sudo apt-get update && sudo apt-get install -y apt-transport-https curl
    sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
KUBEEOF

    # Install xfs progs
    sudo apt-get install xfsprogs

    sudo touch "/iot_stack_ready"
fi
