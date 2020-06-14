#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy flannel network
#echo "[TASK 3] Deploy flannel network"
#su - vagrant -c "kubectl create -f /vagrant/kube-flannel.yml"

# Deploy calico network
echo "[TASK 3] Deploy calico network"
su - vagrant -c "kubectl create -f /vagrant/calico.yml"

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh

# Expose docker API with TLS
#echo "[TASK 5] Expose docker API with TLS"
#mkdir /etc/systemd/system/docker.service.d
#bash -c 'cat >>/etc/systemd/system/docker.service.d/startup_options.conf<<EOF
#[Service]
#ExecStart=
#ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376 --tlsverify --tlscacert=/vagrant/tls/ca.pem --tlscert=/vagrant/tls/server-cert.pem --tlskey=/vagrant/tls/server-key.pem
#EOF'

# Restart docker
#echo "[TASK 6] Restart docker"
#systemctl daemon-reload
#systemctl restart docker.service