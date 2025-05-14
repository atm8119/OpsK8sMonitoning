## EXPECTED TERMINAL OUTPUTS:

# Monitoring Namespace
root@Ubuntu-0152:~# k get -n monitoring svc,deployments,po,ServiceMonitors
NAME                                              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
service/alertmanager-operated                     ClusterIP   None            <none>        9093/TCP,9094/TCP,9094/UDP   28h
service/prometheus-external                       NodePort    10.43.114.98    <none>        9090:30090/TCP               3h56m
service/prometheus-grafana                        ClusterIP   10.43.18.162    <none>        80/TCP                       28h
service/prometheus-kube-prometheus-alertmanager   ClusterIP   10.43.201.218   <none>        9093/TCP,8080/TCP            28h
service/prometheus-kube-prometheus-operator       ClusterIP   10.43.175.232   <none>        443/TCP                      28h
service/prometheus-kube-prometheus-prometheus     ClusterIP   10.43.93.134    <none>        9090/TCP,8080/TCP            28h
service/prometheus-kube-state-metrics             ClusterIP   10.43.223.109   <none>        8080/TCP                     28h
service/prometheus-operated                       ClusterIP   None            <none>        9090/TCP                     28h
service/prometheus-prometheus-node-exporter       ClusterIP   10.43.222.127   <none>        9100/TCP                     28h

NAME                                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prometheus-grafana                    1/1     1            1           28h
deployment.apps/prometheus-kube-prometheus-operator   1/1     1            1           28h
deployment.apps/prometheus-kube-state-metrics         1/1     1            1           28h

NAME                                                         READY   STATUS    RESTARTS        AGE
pod/alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running   2 (5h15m ago)   28h
pod/prometheus-grafana-77bcfb9bdb-882ks                      3/3     Running   3 (5h15m ago)   28h
pod/prometheus-kube-prometheus-operator-759b554bdb-459xg     1/1     Running   1 (5h15m ago)   28h
pod/prometheus-kube-state-metrics-7457555cf7-mnf5p           1/1     Running   1 (5h15m ago)   28h
pod/prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running   2 (5h15m ago)   28h
pod/prometheus-prometheus-node-exporter-lzh89                1/1     Running   1 (5h15m ago)   28h

NAME                                                                                      AGE
servicemonitor.monitoring.coreos.com/prometheus-example-app                               175m
servicemonitor.monitoring.coreos.com/prometheus-grafana                                   28h
servicemonitor.monitoring.coreos.com/prometheus-kube-prometheus-alertmanager              28h
servicemonitor.monitoring.coreos.com/prometheus-kube-prometheus-apiserver                 28h
servicemonitor.monitoring.coreos.com/prometheus-kube-prometheus-coredns                   28h
servicemonitor.monitoring.coreos.com/prometheus-kube-prometheus-kube-controller-manager   28h
servicemonitor.monitoring.coreos.com/prometheus-kube-prometheus-kube-etcd                 28h
servicemonitor.monitoring.coreos.com/prometheus-kube-prometheus-kube-proxy                28h
servicemonitor.monitoring.coreos.com/prometheus-kube-prometheus-kube-scheduler            28h
servicemonitor.monitoring.coreos.com/prometheus-kube-prometheus-kubelet                   28h
servicemonitor.monitoring.coreos.com/prometheus-kube-prometheus-operator                  28h
servicemonitor.monitoring.coreos.com/prometheus-kube-prometheus-prometheus                28h
servicemonitor.monitoring.coreos.com/prometheus-kube-state-metrics                        28h
servicemonitor.monitoring.coreos.com/prometheus-prometheus-node-exporter                  28h

# Test-App Namespace
root@Ubuntu-0152:~# k get -n test-app svc,deployments,po,ServiceMonitors
NAME                             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
service/prometheus-example-app   ClusterIP   10.43.86.28   <none>        8080/TCP   176m

NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prometheus-example-app   2/2     2            2           176m

NAME                                          READY   STATUS    RESTARTS   AGE
pod/new-load-generator-wccvj                  1/1     Running   0          175m
pod/prometheus-example-app-54479854dc-kr9p9   1/1     Running   0          176m
pod/prometheus-example-app-54479854dc-p8hkz   1/1     Running   0          176m
root@Ubuntu-0152:~#
root@Ubuntu-0152:~# k get svc
NAME                                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
alertmanager-operated                     ClusterIP   None            <none>        9093/TCP,9094/TCP,9094/UDP   29h
prometheus-external                       NodePort    10.43.114.98    <none>        9090:30090/TCP               4h47m
prometheus-grafana                        ClusterIP   10.43.18.162    <none>        80/TCP                       29h
prometheus-kube-prometheus-alertmanager   ClusterIP   10.43.201.218   <none>        9093/TCP,8080/TCP            29h
prometheus-kube-prometheus-operator       ClusterIP   10.43.175.232   <none>        443/TCP                      29h
prometheus-kube-prometheus-prometheus     ClusterIP   10.43.93.134    <none>        9090/TCP,8080/TCP            29h
prometheus-kube-state-metrics             ClusterIP   10.43.223.109   <none>        8080/TCP                     29h
prometheus-operated                       ClusterIP   None            <none>        9090/TCP                     29h
prometheus-prometheus-node-exporter       ClusterIP   10.43.222.127   <none>        9100/TCP                     29h
root@Ubuntu-0152:~# kn
default
kube-node-lease
kube-public
kube-system
monitoring
test-app

# Kube-System Namespace
root@Ubuntu-0152:~# k get -n kube-system svc,deployments,po,ServiceMonitors
NAME                                                         TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                        AGE
service/kube-dns                                             ClusterIP      10.43.0.10     <none>           53/UDP,53/TCP,9153/TCP         29h
service/metrics-server                                       ClusterIP      10.43.23.18    <none>           443/TCP                        29h
service/prometheus-kube-prometheus-coredns                   ClusterIP      None           <none>           9153/TCP                       29h
service/prometheus-kube-prometheus-kube-controller-manager   ClusterIP      None           <none>           10257/TCP                      29h
service/prometheus-kube-prometheus-kube-etcd                 ClusterIP      None           <none>           2381/TCP                       29h
service/prometheus-kube-prometheus-kube-proxy                ClusterIP      None           <none>           10249/TCP                      29h
service/prometheus-kube-prometheus-kube-scheduler            ClusterIP      None           <none>           10259/TCP                      29h
service/prometheus-kube-prometheus-kubelet                   ClusterIP      None           <none>           10250/TCP,10255/TCP,4194/TCP   29h
service/traefik                                              LoadBalancer   10.43.52.194   10.200.100.102   80:32268/TCP,443:32237/TCP     29h

NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/coredns                  1/1     1            1           29h
deployment.apps/local-path-provisioner   1/1     1            1           29h
deployment.apps/metrics-server           1/1     1            1           29h
deployment.apps/traefik                  1/1     1            1           29h

NAME                                          READY   STATUS      RESTARTS       AGE
pod/coredns-697968c856-trl5w                  1/1     Running     1 (6h6m ago)   29h
pod/helm-install-traefik-crd-kwn2m            0/1     Completed   0              29h
pod/helm-install-traefik-jvh9x                0/1     Completed   1              29h
pod/local-path-provisioner-774c6665dc-sb7v8   1/1     Running     1 (6h6m ago)   29h
pod/metrics-server-6f4c6675d5-f58ds           1/1     Running     1 (6h6m ago)   29h
pod/svclb-traefik-a3e41b5e-l942s              2/2     Running     2 (6h6m ago)   29h
pod/traefik-c98fdf6fb-5cf9f                   1/1     Running     1 (6h6m ago)   29h
