## 配置 kubeadm

安装 kubernetes 主要是安装它的各个镜像，而 kubeadm 已经为我们集成好了运行 kubernetes 所需的基本镜像。但由于国内的网络原因，在搭建环境时，无法拉取到这些镜像。此时我们只需要修改为阿里云提供的镜像服务即可解决该问题。

```bash
root@ubuntu2:/usr/local/kubernetes# pwd
/usr/local/kubernetes

# 导出配置文件
kubeadm config print init-defaults --kubeconfig ClusterConfiguration > kubeadm.yml
```

```bash
root@ubuntu2:/usr/local/kubernetes# vim kubeadm.yml 

apiVersion: kubeadm.k8s.io/v1beta2
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  # 修改为主节点 IP
  advertiseAddress: 192.168.100.140
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  # 修改为主机名
  name: kubenetes-slave3
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta2
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns:
  type: CoreDNS
etcd:
  local:
    dataDir: /var/lib/etcd
# 国内不能访问 Google，修改为阿里云
imageRepository: registry.aliyuncs.com/google_containers
kind: ClusterConfiguration
# 修改版本号
kubernetesVersion: v1.19.3
networking:
  dnsDomain: cluster.local
  # 配置成 Calico 的默认网段
  podSubnet: "192.168.0.0/16"
  serviceSubnet: 10.96.0.0/12
scheduler: {}

---
# 开启 IPVS 模式
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
featureGates:
  SupportIPVSProxyMode: true
mode: ipvs
```

### 查看和拉取镜像

```bash
# 查看所需镜像列表
kubeadm config images list --config kubeadm.yml
oot@ubuntu2:/usr/local/kubernetes# kubeadm config images list --config kubeadm.yml
W1103 08:36:40.039429    7420 configset.go:348] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
registry.aliyuncs.com/google_containers/kube-apiserver:v1.19.3
registry.aliyuncs.com/google_containers/kube-controller-manager:v1.19.3
registry.aliyuncs.com/google_containers/kube-scheduler:v1.19.3
registry.aliyuncs.com/google_containers/kube-proxy:v1.19.3
registry.aliyuncs.com/google_containers/pause:3.2
registry.aliyuncs.com/google_containers/etcd:3.4.13-0
registry.aliyuncs.com/google_containers/coredns:1.7.0

# 拉取镜像
kubeadm config images pull --config kubeadm.yml
root@ubuntu2:/usr/local/kubernetes# kubeadm config images pull --config kubeadm.yml
W1103 08:37:11.323242    7558 configset.go:348] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
[config/images] Pulled registry.aliyuncs.com/google_containers/kube-apiserver:v1.19.3
[config/images] Pulled registry.aliyuncs.com/google_containers/kube-controller-manager:v1.19.3
[config/images] Pulled registry.aliyuncs.com/google_containers/kube-scheduler:v1.19.3
[config/images] Pulled registry.aliyuncs.com/google_containers/kube-proxy:v1.19.3
[config/images] Pulled registry.aliyuncs.com/google_containers/pause:3.2
[config/images] Pulled registry.aliyuncs.com/google_containers/etcd:3.4.13-0
[config/images] Pulled registry.aliyuncs.com/google_containers/coredns:1.7.0

#查看镜像
root@ubuntu2:/usr/local/kubernetes# docker images
REPOSITORY                                                        TAG                 IMAGE ID            CREATED             SIZE
registry.aliyuncs.com/google_containers/kube-proxy                v1.19.3             cdef7632a242        2 weeks ago         118MB
registry.aliyuncs.com/google_containers/kube-apiserver            v1.19.3             a301be0cd44b        2 weeks ago         119MB
registry.aliyuncs.com/google_containers/kube-controller-manager   v1.19.3             9b60aca1d818        2 weeks ago         111MB
registry.aliyuncs.com/google_containers/kube-scheduler            v1.19.3             aaefbfa906bd        2 weeks ago         45.7MB
registry.aliyuncs.com/google_containers/etcd                      3.4.13-0            0369cf4303ff        2 months ago        253MB
registry.aliyuncs.com/google_containers/coredns                   1.7.0               bfe3a36ebd25        4 months ago        45.2MB
registry.aliyuncs.com/google_containers/pause                     3.2                 80d28bedfe5d        8 months ago        683kB

```

