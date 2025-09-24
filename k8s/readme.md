# Helm Installation
```bash
sudo apt-get install curl gpg apt-transport-https --yes
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

# Promethus Installation
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace 
```
 
# Verify Crd
```bash
kubectl get crd | grep servicemonitors
```

# List all service with port 9090
```bash
lsof -i :9090
```

# port-forwarding 
```bash
kubectl port-forward svc/prometheus-stack-kube-prom-prometheus -n monitoring 9090:9090 &
```

# Install jq for get response in json formate
```bash
sudo apt-get update && sudo apt-get install -y jq
jq --version
```

# check custome metrics target up/down
```bash
curl -s 127.0.0.1:9090/api/v1/targets | grep ws-svc -A10
```
or
```bash
curl -s 127.0.0.1:9090/api/v1/targets \
  | jq -r '.data.activeTargets[]
    | select(.labels.service=="ws-svc")
    | {job: .labels.job, service: .labels.service, namespace: .labels.namespace, scrapeUrl: .scrapeUrl, health: .health, lastScrape: .lastScrape}'
```

# all up targets 
```bash
curl -s 127.0.0.1:9090/api/v1/targets \
  | jq -r '.data.activeTargets[]
    | select(.health == "up")
    | {job: .labels.job, service: .labels.service, namespace: .labels.namespace, scrapeUrl: .scrapeUrl, health: .health, lastScrape: .lastScrape}'
```

# all down targets
```bash
curl -s 127.0.0.1:9090/api/v1/targets \
  | jq -r '.data.activeTargets[]
    | select(.health == "down")
    | {job: .labels.job, service: .labels.service, namespace: .labels.namespace, scrapeUrl: .scrapeUrl, health: .health, lastScrape: .lastScrape}'
```


