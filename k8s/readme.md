# Helm Installation
sudo apt-get install curl gpg apt-transport-https --yes
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# PROMETHUS INSTALLATION
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace 
 
# VERFIY CRD
kubectl get crd | grep servicemonitors

# List all service with port 9090
lsof -i :9090

# port-forwarding 
kubectl port-forward svc/prometheus-stack-kube-prom-prometheus -n monitoring 9090:9090 &

# Install jq for get response in json formate
sudo apt-get update && sudo apt-get install -y jq
jq --version

# check custome metrics target up/down
curl -s 127.0.0.1:9090/api/v1/targets | grep ws-svc -A10
or
curl -s 127.0.0.1:9090/api/v1/targets \
  | jq -r '.data.activeTargets[]
    | select(.labels.service=="ws-svc")
    | {job: .labels.job, service: .labels.service, namespace: .labels.namespace, scrapeUrl: .scrapeUrl, health: .health, lastScrape: .lastScrape}'

# all up targets 
curl -s 127.0.0.1:9090/api/v1/targets \
  | jq -r '.data.activeTargets[]
    | select(.health == "up")
    | {job: .labels.job, service: .labels.service, namespace: .labels.namespace, scrapeUrl: .scrapeUrl, health: .health, lastScrape: .lastScrape}'

# all down targets
curl -s 127.0.0.1:9090/api/v1/targets \
  | jq -r '.data.activeTargets[]
    | select(.health == "down")
    | {job: .labels.job, service: .labels.service, namespace: .labels.namespace, scrapeUrl: .scrapeUrl, health: .health, lastScrape: .lastScrape}'


