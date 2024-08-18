This project provides resources for deploying a kubernetes cluster.

The "configure_node.sh" script is to be executed on all nodes of the cluster.
It installs and configures the necessary components to prepare the cluster
(kubeadm, kubelet, kubectl, container runtime...)

Next, the "init_control_plane.sh" script is used to set up the control plane and
should thus be executed on that node.
The worker nodes should then be joined using the instructions given by the
output of the script.

Additionally, the "setup_kubectl_locally.sh" script sets up kubectl to access the
control plane that was configured at the previous step.

The "setup_default_storage_class.sh" script creates a default storage class using
https://github.com/rancher/local-path-provisioner)
