# VMware Aria Operations: Minimum Required Permissions for K8s Monitoring

## Scope
This has been tested on:
- K3s Cluster

## Executive Summary

Our testing has identified that VMware Aria Operations (VCF Operations) requires just **two core permission sets** to successfully monitor a K3s Kubernetes cluster:

1. **Standard read-only access** to all Kubernetes resources
2. **Non-resource URL access** to cluster metrics endpoints

This is significantly more restricted than a full cluster-admin role, allowing for proper security boundaries while enabling complete monitoring functionality.

## Detailed Permission Requirements

### Core Required Permissions

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: vmware-aria-ops-minimum
rules:
# Read access to all resources
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
# Non-resource URL access
- nonResourceURLs: ["*"]
  verbs: ["get", "head"]
```

### Understanding These Permissions

1. **Resource Read Access** (`apiGroups: ["*"]`, `resources: ["*"]`, `verbs: ["get", "list", "watch"]`)
   - Allows **read-only** access to all Kubernetes resources
   - Covers standard objects (pods, services, deployments)
   - Includes custom resources (ServiceMonitors, etc.)
   - Zero write/modify permissions

2. **Non-Resource URL Access** (`nonResourceURLs: ["*"]`, `verbs: ["get", "head"]`)
   - Grants access to special API endpoints not tied to resources
   - Critical endpoints include:
     - `/metrics` - Exposes Prometheus metrics
     - `/healthz` - Health check endpoints
     - `/api`, `/apis` - API discovery endpoints
     - `/version` - Kubernetes version information
   - This permission was the missing piece in standard "view" roles

## Implementation Guide

### Production-Ready Service Account Setup

```bash
# 1. Create dedicated service account
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

# 5. Get the token for VMware Aria Operations
kubectl get secret vmware-aria-ops-token -n kube-system -o jsonpath='{.data.token}' | base64 --decode
```

### VMware Aria Operations Configuration

1. **In the VMware Aria Operations UI**:
   - Navigate to Administration → Integrations → Adapters
   - Add a new Kubernetes adapter
   - Use "Token Auth" as the Credential Kind
   - Paste the token generated in step 5 above
   - Set Control Plane URL to `https://[K3S_IP]:6443`
   - Set Prometheus Server to `http://[K3S_IP]:30090/`

## Security Considerations

1. **Principle of Least Privilege**: This role provides minimum required access for monitoring without any modification capabilities.

2. **Isolated Service Account**: Using a dedicated service account isolates the monitoring permissions from other system components.

3. **Non-Resource URLs**: While access to all non-resource URLs is granted, this is read-only (`get`, `head`) with no write capabilities.

4. **Zero Modification Access**: Unlike cluster-admin, this role cannot modify any cluster resources, significantly reducing security risk.

## Technical Explanation: Why These Permissions

1. **Why Non-Resource URLs Matter**: VMware Aria Operations needs to access special metrics endpoints that aren't represented as standard Kubernetes resources. These endpoints provide critical performance data.

2. **Why the Standard "view" Role Was Insufficient**: The built-in "view" role provides resource access but lacks non-resource URL permissions, preventing VMware Aria Operations from accessing metrics endpoints.

3. **Previous Error Analysis**: The misleading "Credentials provided do not have 'Read' access to the cluster" error was actually referring to the inability to access non-resource metrics endpoints, not standard resources.

## Takeaway

By implementing these minimal permissions, you maintain strong security boundaries while enabling full monitoring capabilities.
