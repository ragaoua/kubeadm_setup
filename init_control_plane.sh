# SEE https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

set -e

readonly pod_network_cidr="10.244.0.0/16"

# 1. Setup the control plane 
sudo kubeadm init --pod-network-cidr="$pod_network_cidr"

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 2. Install a Pod network add-on (Weave Net)
kubectl apply -f https://github.com/rajch/weave/releases/latest/download/weave-daemonset-k8s-1.11.yaml

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "Don't forget to edit the weave-net daemonSet to add this env variable in the \"weave\" container :"
echo "  - name: IPALLOC_RANGE"
echo "    value: $pod_network_cidr"
echo "Then, join the worker nodes to the cluster using the command provided by kubeadm init"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
