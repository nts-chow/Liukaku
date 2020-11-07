## 配置网络

### 概述

容器网络是容器选择连接到其他容器、主机和外部网络的机制。容器的 runtime 提供了各种网络模式，每种模式都会产生不同的体验。例如，Docker 默认情况下可以为容器配置以下网络：

- **none：** 将容器添加到一个容器专门的网络堆栈中，没有对外连接。
- **host：** 将容器添加到主机的网络堆栈中，没有隔离。
- **default bridge：** 默认网络模式。每个容器可以通过 IP 地址相互连接。
- **自定义网桥：** 用户定义的网桥，具有更多的灵活性、隔离性和其他便利功能。

## [#](https://www.funtl.com/zh/service-mesh-kubernetes/配置网络.html#什么是-cni)什么是 CNI

CNI(Container Network Interface) 是一个标准的，通用的接口。在容器平台，Docker，Kubernetes，Mesos 容器网络解决方案 flannel，calico，weave。只要提供一个标准的接口，就能为同样满足该协议的所有容器平台提供网络功能，而 CNI 正是这样的一个标准接口协议。

## [#](https://www.funtl.com/zh/service-mesh-kubernetes/配置网络.html#kubernetes-中的-cni-插件)Kubernetes 中的 CNI 插件

CNI 的初衷是创建一个框架，用于在配置或销毁容器时动态配置适当的网络配置和资源。插件负责为接口配置和管理 IP 地址，并且通常提供与 IP 管理、每个容器的 IP 分配、以及多主机连接相关的功能。容器运行时会调用网络插件，从而在容器启动时分配 IP 地址并配置网络，并在删除容器时再次调用它以清理这些资源。

运行时或协调器决定了容器应该加入哪个网络以及它需要调用哪个插件。然后，插件会将接口添加到容器网络命名空间中，作为一个 veth 对的一侧。接着，它会在主机上进行更改，包括将 veth 的其他部分连接到网桥。再之后，它会通过调用单独的 IPAM（IP地址管理）插件来分配 IP 地址并设置路由。

在 Kubernetes 中，kubelet 可以在适当的时间调用它找到的插件，为通过 kubelet 启动的 pod进行自动的网络配置。

Kubernetes 中可选的 CNI 插件如下：

- Flannel
- Calico
- Canal
- Weave

## [#](https://www.funtl.com/zh/service-mesh-kubernetes/配置网络.html#什么是-calico)什么是 Calico

Calico 为容器和虚拟机提供了安全的网络连接解决方案，并经过了大规模生产验证（在公有云和跨数千个集群节点中），可与 Kubernetes，OpenShift，Docker，Mesos，DC / OS 和 OpenStack 集成。

Calico 还提供网络安全规则的动态实施。使用 Calico 的简单策略语言，您可以实现对容器，虚拟机工作负载和裸机主机端点之间通信的细粒度控制。

## [#](https://www.funtl.com/zh/service-mesh-kubernetes/配置网络.html#安装网络插件-calico)安装网络插件 Calico

> 注意：截止到文章发表日期 2019 年 05 月 11 日，Calico 官方版本为 3.7

参考官方文档安装：https://docs.projectcalico.org/v3.7/getting-started/kubernetes/

```bash
# 在 Master 节点操作即可
# 2019版本kubectl apply -f https://docs.projectcalico.org/v3.7/manifests/calico.yaml
kubectl apply -f https://docs.projectcalico.org/v3.15/manifests/calico.yaml
# 安装时显示如下输出
configmap/calico-config created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
clusterrole.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrolebinding.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrole.rbac.authorization.k8s.io/calico-node created
clusterrolebinding.rbac.authorization.k8s.io/calico-node created
daemonset.extensions/calico-node created
serviceaccount/calico-node created
deployment.extensions/calico-kube-controllers created
serviceaccount/calico-kube-controllers created
```

确认安装是否成功

```bash
watch kubectl get pods --all-namespaces

# 需要等待所有状态为 Running，注意时间可能较久，3 - 5 分钟的样子
Every 2.0s: kubectl get pods --all-namespaces                                                                                                    kubernetes-master: Fri May 10 18:16:51 2019

NAMESPACE     NAME                                        READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-8646dd497f-g2lln    1/1     Running   0          50m
kube-system   calico-node-8jrtp                           1/1     Running   0          50m
kube-system   coredns-8686dcc4fd-mhwfn                    1/1     Running   0          51m
kube-system   coredns-8686dcc4fd-xsxwk                    1/1     Running   0          51m
kube-system   etcd-kubernetes-master                      1/1     Running   0          50m
kube-system   kube-apiserver-kubernetes-master            1/1     Running   0          51m
kube-system   kube-controller-manager-kubernetes-master   1/1     Running   0          51m
kube-system   kube-proxy-p8mdw                            1/1     Running   0          51m
kube-system   kube-scheduler-kubernetes-master            1/1     Running   0          51m
```

至此基本环境已部署完毕。

## [#](https://www.funtl.com/zh/service-mesh-kubernetes/配置网络.html#解决-imagepullbackoff)解决 ImagePullBackOff

在使用 `watch kubectl get pods --all-namespaces` 命令观察 Pods 状态时如果出现 `ImagePullBackOff` 无法 Running 的情况，请尝试使用如下步骤处理：

- Master 中删除 Nodes：`kubectl delete nodes <NAME>`
- Slave 中重置配置：`kubeadm reset`
- Slave 重启计算机：`reboot`
- Slave 重新加入集群：`kubeadm join`

### 附：配置固定 IP 和 DNS

当关机后再启动虚拟机有时 IP 地址会自动更换，导致之前的配置不可用；配置完 Kubernetes 网络后虚拟机还会出现无法联网的情况，后经研究发现是 DNS 会被自动重写所致，Ubuntu Server 18.04 LTS 版本的 IP 和 DNS 配置也与之前的版本配置大相径庭，故在此说明下如何修改 IP 和 DNS

### 修改固定 IP

编辑 `vi /etc/netplan/50-cloud-init.yaml` 配置文件，注意这里的配置文件名未必和你机器上的相同，请根据实际情况修改。修改内容如下：

```yaml
network:
    ethernets:
        ens33:
          addresses: [192.168.100.140/24]
          gateway4: 192.168.100.1
          nameservers:
            addresses: [192.168.100.1]
    version: 2
```

使配置生效 `netplan apply`

### 修改 DNS

#### 方法一

- 停止 `systemd-resolved` 服务：`systemctl stop systemd-resolved`
- 修改 DNS：`vi /etc/resolv.conf`，将 `nameserver` 修改为如 `114.114.114.114` 可以正常使用的 DNS 地址

#### 方法二

```bash
vi /etc/systemd/resolved.conf
```

把 DNS 取消注释，添加 DNS，保存退出，重启即可