## 安装 kubeadm

kubeadm 是 kubernetes 的集群安装工具，能够快速安装 kubernetes 集群。

### 配置软件源

```bash
# 安装系统工具
apt-get update && apt-get install -y apt-transport-https
# 安装 GPG 证书
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
# 写入软件源；注意：我们用系统代号为 bionic，但目前阿里云不支持，所以沿用 16.04 的 xenial
cat << EOF >/etc/apt/sources.list.d/kubernetes.list
> deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
> EOF

#报错：Certificate verification failed: The certificate is NOT trusted  直接把https改成http
deb http://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
#报错：The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 6A030B21BA07F4FB
#如果上面http改到得话则执行
curl http://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add 
#否则https执行下面
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add 
```

### 安装 kubeadm，kubelet，kubectl

```bash
# 安装
apt-get update  
apt-get install -y kubelet kubeadm kubectl

# 安装过程如下，注意 kubeadm 的版本号
root@ubuntu2:/# apt-get install -y kubelet kubeadm kubectl
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  conntrack cri-tools kubernetes-cni socat
The following NEW packages will be installed:
  conntrack cri-tools kubeadm kubectl kubelet kubernetes-cni socat
0 upgraded, 7 newly installed, 0 to remove and 64 not upgraded.
Need to get 68.5 MB of archives.
After this operation, 292 MB of additional disk space will be used.
Get:1 http://mirrors.aliyun.com/ubuntu bionic/main amd64 conntrack amd64 1:1.4.4+snapshot20161117-6ubuntu2 [30.6 kB]
Get:2 http://mirrors.aliyun.com/ubuntu bionic/main amd64 socat amd64 1.7.3.2-2ubuntu2 [342 kB]
Get:3 https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial/main amd64 cri-tools amd64 1.13.0-01 [8,775 kB]                                                            
Get:4 https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial/main amd64 kubernetes-cni amd64 0.8.7-00 [25.0 MB]                                                         
Get:5 https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial/main amd64 kubelet amd64 1.19.3-00 [18.2 MB]                                                               
Get:6 https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial/main amd64 kubectl amd64 1.19.3-00 [8,350 kB]                                                              
Get:7 https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial/main amd64 kubeadm amd64 1.19.3-00 [7,758 kB]                                                              
Fetched 68.5 MB in 22min 30s (50.7 kB/s)                                                                                                                                     
Selecting previously unselected package conntrack.
(Reading database ... 67347 files and directories currently installed.)
Preparing to unpack .../0-conntrack_1%3a1.4.4+snapshot20161117-6ubuntu2_amd64.deb ...
Unpacking conntrack (1:1.4.4+snapshot20161117-6ubuntu2) ...
Selecting previously unselected package cri-tools.
Preparing to unpack .../1-cri-tools_1.13.0-01_amd64.deb ...
Unpacking cri-tools (1.13.0-01) ...
Selecting previously unselected package kubernetes-cni.
Preparing to unpack .../2-kubernetes-cni_0.8.7-00_amd64.deb ...
Unpacking kubernetes-cni (0.8.7-00) ...
Selecting previously unselected package socat.
Preparing to unpack .../3-socat_1.7.3.2-2ubuntu2_amd64.deb ...
Unpacking socat (1.7.3.2-2ubuntu2) ...
Selecting previously unselected package kubelet.
Preparing to unpack .../4-kubelet_1.19.3-00_amd64.deb ...
Unpacking kubelet (1.19.3-00) ...
Selecting previously unselected package kubectl.
Preparing to unpack .../5-kubectl_1.19.3-00_amd64.deb ...
Unpacking kubectl (1.19.3-00) ...
Selecting previously unselected package kubeadm.
Preparing to unpack .../6-kubeadm_1.19.3-00_amd64.deb ...
Unpacking kubeadm (1.19.3-00) ...
Setting up conntrack (1:1.4.4+snapshot20161117-6ubuntu2) ...
Setting up kubernetes-cni (0.8.7-00) ...
Setting up cri-tools (1.13.0-01) ...
Setting up socat (1.7.3.2-2ubuntu2) ...
Setting up kubelet (1.19.3-00) ...
Created symlink /etc/systemd/system/multi-user.target.wants/kubelet.service → /lib/systemd/system/kubelet.service.
Setting up kubectl (1.19.3-00) ...
# 注意这里的版本号，我们使用的是 kubernetes v1.19.3
Setting up kubeadm (1.19.3-00) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...

# 设置 kubelet 自启动，并启动 kubelet
systemctl enable kubelet && systemctl start kubelet
```


kubeadm：用于初始化 Kubernetes 集群

kubectl：Kubernetes 的命令行工具，主要作用是部署和管理应用，查看各种资源，创建，删除和更新组件

kubelet：主要负责启动 Pod 和容器