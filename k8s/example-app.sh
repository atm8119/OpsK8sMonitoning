## NAMESPACE -- Create a new namespace 'test-app' for the Prometheus example app
kubectl create namespace test-app

## DEPLOYMENT & SERVICE -- Create a deployment with the Prometheus example app
cat > prometheus-example-app.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus-example-app
  namespace: test-app
  labels:
    app: prometheus-example-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: prometheus-example-app
  template:
    metadata:
      labels:
        app: prometheus-example-app
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/path: "/metrics"
        prometheus.io/port: "8080"
    spec:
      containers:
      - name: prometheus-example-app
        image: prom/prometheus:v2.37.0
        args:
        - --config.file=/etc/prometheus/prometheus.yml
        - --web.listen-address=:8080
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: prometheus-config
          mountPath: /etc/prometheus
      volumes:
      - name: prometheus-config
        configMap:
          name: example-prometheus-config
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus-example-app
  namespace: test-app
  labels:
    app: prometheus-example-app
spec:
  ports:
  - port: 8080
    targetPort: 8080
    name: web
  selector:
    app: prometheus-example-app
EOF

# Create a simple Prometheus config ConfigMap
cat > example-prometheus-config.yaml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-prometheus-config
  namespace: test-app
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
    scrape_configs:
kubectl apply -f prometheus-example-app.yaml
  


## SERVICEMONITOR -- Create a ServiceMonitor for our example app
cat > example-app-servicemonitor.yaml << EOF
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: prometheus-example-app
  namespace: monitoring
  labels:
    release: prometheus
spec:
  namespaceSelector:
    matchNames:
    - test-app
  selector:
    matchLabels:
      app: prometheus-example-app
  endpoints:
  - port: web
    path: /metrics
    interval: 15s
EOF
kubectl apply -f example-app-servicemonitor.yaml

## LOAD GENERATOR -- Create a new load generator
cat > new-load-generator.yaml << EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: new-load-generator
  namespace: test-app
spec:
  template:
    spec:
      containers:
      - name: load-generator
        image: busybox
        command:
        - /bin/sh
        - -c
        - |
          while true; do
            for i in {1..30}; do
              wget -q -O- http://prometheus-example-app:8080/metrics
              sleep 0.5
            done
            echo "Generated 30 requests"
            sleep 5
          done
      restartPolicy: Never
  backoffLimit: 4
EOF
kubectl apply -f new-load-generator.yaml


## VALIDATE -------------------
## CHECK-PODS Check the pods in the test-app namespace
kubectl get pods -n test-app

## CHECK-SERVICE-MONITOR Verify the ServiceMonitor is created
kubectl get servicemonitor -n monitoring

## CHECK-PROMETHEUS-COLLECTION Check that Prometheus is scraping our new target
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
