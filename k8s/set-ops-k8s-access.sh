# Create ServiceAccount with access to Kubelet API
# 1. Create dedicated service account with access to Cluster Resources including Non-Resource-URLs (e.g. /metrics) 
kubectl create serviceaccount vmware-aria-ops -n kube-system

# 2. Create minimum permission role
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: vmware-aria-ops-minimum
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- nonResourceURLs: ["*"]
  verbs: ["get", "head"]
EOF

# 3. Bind the role to the service account
kubectl create clusterrolebinding vmware-aria-ops-minimum --clusterrole=vmware-aria-ops-minimum --serviceaccount=kube-system:vmware-aria-ops

# 4. Create a token for the service account
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: vmware-aria-ops-token
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: vmware-aria-ops
type: kubernetes.io/service-account-token
EOF

# 5. Get the token for VMware Aria Operations (Auth Token approach | "Bearer Token" field)
kubectl get secret vmware-aria-ops-token -n kube-system -o jsonpath='{.data.token}' | base64 --decode

