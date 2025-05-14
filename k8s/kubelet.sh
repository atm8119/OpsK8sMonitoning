# Create ServiceAccount with access to Kubelet API
cat > kubelet-access-rbac.yaml << EOF 
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kubelet-metrics-viewer
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: kubelet-metrics-viewer
rules:
- apiGroups: [""]
  resources: ["nodes/proxy", "nodes/metrics", "nodes/stats"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kubelet-metrics-viewer
subjects:
- kind: ServiceAccount
  name: kubelet-metrics-viewer
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: kubelet-metrics-viewer
  apiGroup: rbac.authorization.k8s.io
EOF 
kubectl apply -f kubelet-access-rbac.yaml

# Expose Kubelet API to VCF Operations (in our case, for simplicity, using NodePort)
cat > kubelet-api-nodeport.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: kubelet-external
  namespace: kube-system
spec:
  type: NodePort
  ports:
  - name: https-kubelet
    port: 10250
    targetPort: 10250
    nodePort: 30250
    protocol: TCP
  selector:
    # Empty selector since we want this to apply to the node itself
    # For k3s, you might need to adjust this based on your specific setup
    k8s-app: kubelet
EOF
kubectl apply -f kubelet-api-nodeport.yaml

# Get Service Account Token to add to VCF Operations
kubectl -n kube-system get secret $(kubectl -n kube-system get serviceaccount kubelet-metrics-viewer -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode
