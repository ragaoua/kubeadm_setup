#!/bin/bash

set -e

control_plane="$1"
if [ -z "$1" ] ; then
  read -p "Enter control plane host : " control_plane
fi
readonly control_plane

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
sudo dnf install -y kubectl --disableexcludes=kubernetes

mkdir $HOME/.kube
ssh "$control_plane" 'cat $HOME/.kube/config' >$HOME/.kube/config

sudo bash -c "kubectl completion bash > /etc/profile.d/00-kubectl_completion.sh"
sudo curl -s https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias -o /etc/profile.d/00-completion_alias.sh
cat <<EOF | sudo tee /etc/profile.d/01-kubectl_aliases.sh
alias k="kubectl"
alias kd="kubectl describe"
alias ka="kubectl apply -f"
complete -F _complete_alias k
complete -F _complete_alias kd
complete -F _complete_alias ka
EOF
source /etc/profile.d/00-kubectl_completion.sh
source /etc/profile.d/00-completion_alias.sh
source /etc/profile.d/01-kubectl_aliases.sh
