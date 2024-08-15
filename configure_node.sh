# SEE https://kubernetes.io/fr/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

set -e

readonly os="centos" # Centos for Alma too

# 1. Install the container runtime
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

sudo modprobe ip_tables
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
iptables
EOF

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo "https://download.docker.com/linux/$os/docker-ce.repo"
sudo dnf install containerd.io -y

cat <<EOF | sudo tee /etc/containerd/config.toml
version = 2

[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
    sandbox_image = "registry.k8s.io/pause:3.10"
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
      runtime_type = "io.containerd.runc.v2"
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
        SystemdCgroup = true
EOF
sudo systemctl start containerd
sudo systemctl enable containerd

# 2. Install kubeadm, kublet and kubectl
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

cat <<EOF | sudo tee /etc/sysconfig/kubelet
KUBELET_EXTRA_ARGS="--fail-swap-on=false"
EOF
sudo systemctl enable --now kubelet

cat <<EOF | sudo tee /etc/profile.d/k8s.sh
alias k="kubectl"
EOF
