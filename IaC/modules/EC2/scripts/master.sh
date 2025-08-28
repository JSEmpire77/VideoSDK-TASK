#!/bin/bash

echo ">> Disabling Swap..."
swapoff -a || true
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo ">> Enabling IPv4 forwarding..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg lsb-release -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
 sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo ">> Installing containerd if not already installed..."
sudo apt-get update -y
sudo apt-get install -y containerd.io

sudo containerd config default > /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

udo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Initialize Kubernetes Control Plane
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --node-name master --upload-certs

# Set kubeconfig
export KUBECONFIG=/etc/kubernetes/admin.conf

# Set up kubectl for root user
mkdir -p /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config
chown root:root /root/.kube/config

# Wait until the kube-apiserver pod is ready
echo "Waiting for kube-apiserver pod to be ready..."
for i in {1..60}; do
    READY=$(kubectl get pods -n kube-system -l component=kube-apiserver -o jsonpath='{.items[0].status.conditions[?(@.type=="Ready")].status}')
    if [ "$READY" == "True" ]; then
        echo "kube-apiserver is Ready!"
        break
    else
        echo "Waiting for kube-apiserver... attempt $i"
        sleep 5
    fi
done



# Install Calico via Helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

helm repo add projectcalico https://docs.tigera.io/calico/charts
kubectl create namespace tigera-operator
helm install calico projectcalico/tigera-operator --version v3.29.3 --namespace tigera-operator

# --- Install AWS CLI v2 ---
sudo apt-get install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

# Generate join command
JOIN_COMMAND=$(kubeadm token create --print-join-command)

# Store join command in AWS SSM Parameter Store
aws ssm put-parameter \
  --name "CDS2438-SSM" \
  --type "SecureString" \
  --value "$JOIN_COMMAND" \
  --overwrite \
  --region us-east-1

echo "Join command stored in SSM successfully."
echo "Master setup complete! You can now join workers by fetching join_command.sh"