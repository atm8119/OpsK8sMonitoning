
# Install Helm if not already installed
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Add the Prometheus community Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create a namespace for monitoring
kubectl create namespace monitoring

# Install Prometheus using Helm
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.service.type=NodePort


# Create a dedicated service for Prometheus
cat > prometheus-service.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: prometheus-server
  namespace: monitoring
  labels:
    app: prometheus
spec:
  ports:
  - port: 9090
    targetPort: 9090
    name: web
  selector:
    app.kubernetes.io/name: prometheus
    prometheus: prometheus-kube-prometheus-prometheus
EOF
kubectl apply -f prometheus-service.yaml

# If your K3s has Traefik as the ingress controller (default for K3s), create an ingress
cat > prometheus-ingress.yaml << EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: prometheus-ingress
  namespace: monitoring
spec:
  rules:
  - host: prometheus.local  # You can replace with your desired hostname
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: prometheus-server
            port:
              number: 9090
EOF
kubectl apply -f prometheus-ingress.yaml


