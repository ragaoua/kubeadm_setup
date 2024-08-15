This project provides resources for deploying a kubernetes cluster.

The "configure_node.sh" script is to be executed on all nodes of the cluster.
It installs and configures the necessary components to prepare the cluster
(kubeadm, kubelet, kubectl, container runtime...)

Next, the "init_control_plane.sh" script is used to set up the controle_plane.
