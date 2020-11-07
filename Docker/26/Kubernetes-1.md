## Kubernetes 安装前的准备

本次安装采用 ubuntu-18.04.4-live-server-amd64.iso 在线安装，可以避免下载一些不需要得镜像
<http://old-releases.ubuntu.com/releases/18.04.4/ubuntu-18.04-live-server-amd64.iso>

安装遇见 Configure Ubuntu archive mirror时候填写阿里云镜像源 ,其余可以参照一般安装
<http://mirrors.aliyun.com/ubuntu/>

### 登录之后更改root用户密码

```bash
#查看镜像地址
xxxx@ubuntu2:~$ sudo apt-get update
#修改root账户密码
xxxx@ubuntu2:~$ sudo passwd root
#登录试试
xxxx@ubuntu2:~$ su
Password: 
#修改/etc/ssh/sshd_config,增加一行  PermitRootLogin yes
root@ubuntu2:~# vi /etc/ssh/sshd_config 

    #PermitRootLogin prohibit-password
    PermitRootLogin yes
    #StrictModes yes
#重启ssh服务，就可以远程用root账户登录ssh了
root@ubuntu2:/home/andre# service ssh restart
```

```bash
#关闭交换空间：sudo swapoff -a  阿里云不需要关闭，交换空间消耗很大，Kubernetes 安装时候会报错
root@ubuntu2:~# free -h
              total        used        free      shared  buff/cache   available
Mem:           1.9G        198M        1.0G        1.2M        770M        1.6G
Swap:          2.0G          0B        2.0G
root@ubuntu2:~# swapoff -a
root@ubuntu2:~# free -h
              total        used        free      shared  buff/cache   available
Mem:           1.9G        197M        1.0G        1.2M        770M        1.6G
Swap:            0B          0B          0B
#避免开机启动交换空间：注释 /etc/fstab 中的 swap
root@ubuntu2:~# vi /etc/fstab
    /dev/disk/by-uuid/343408fa-4d3b-44d4-a514-15ba1adad919 /boot ext4 defaults 0 0
    #/swap.img      none    swap    sw      0       0
#关闭防火墙：ufw disable
root@ubuntu2:~# ufw disable
Firewall stopped and disabled on system startup
```

### 安装Docker

```bash
# 更新软件源
apt-get update
# 安装所需依赖
apt-get -y install apt-transport-https ca-certificates curl software-properties-common
# 安装 GPG 证书
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
# 新增软件源信息
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
# 再次更新软件源
apt-get -y update
# 安装 Docker CE 版
apt-get -y install docker-ce
```

### 查看Docker版本

```bash
root@ubuntu2:~# docker version
Client: Docker Engine - Community
 Version:           19.03.13
 API version:       1.40
 Go version:        go1.13.15
 Git commit:        4484c46d9d
 Built:             Wed Sep 16 17:02:36 2020
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.13
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.13.15
  Git commit:       4484c46d9d
  Built:            Wed Sep 16 17:01:06 2020
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.3.7
  GitCommit:        8fba4e9a7d01810a393d5d25a3621dc101981175
 runc:
  Version:          1.0.0-rc10
  GitCommit:        dc9208a3303feef5b3839f4323d9beb36df0a9dd
 docker-init:
  Version:          0.18.0
  GitCommit:        fec3683
```

### 配置加速器

对于使用 **systemd** 的系统，请在 `/etc/docker/daemon.json` 中写入如下内容（如果文件不存在请新建该文件）

```bash
{
  "registry-mirrors": [
    "https://registry.docker-cn.com"
  ]
}
```

验证加速器是否配置成功

```bash
sudo systemctl restart docker
docker info
...
# 出现如下语句即表示配置成功
Registry Mirrors:
 https://registry.docker-cn.com/
...
```

### 修改主机名

在同一局域网中主机名不应该相同，所以我们需要做修改，下列操作步骤为修改 **18.04** 版本的 Hostname，如果是 16.04 或以下版本则直接修改 `/etc/hostname` 里的名称即可

```bash
# 查看当前主机名
hostnamectl
# 显示如下内容
   Static hostname: ubuntu
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 33011e0a95094672b99a198eff07f652
           Boot ID: dc856039f0d24164a9f8a50c506be96d
    Virtualization: vmware
  Operating System: Ubuntu 18.04.2 LTS
            Kernel: Linux 4.15.0-48-generic
      Architecture: x86-64
# 使用 hostnamectl 命令修改，其中 kubernetes-master 为新的主机名
hostnamectl set-hostname kubernetes-master
```

### 修改 cloud.cfg

如果 `cloud-init package` 安装了，需要修改 `cloud.cfg` 文件。该软件包通常缺省安装用于处理 cloud

```bash
# 如果有该文件
vi /etc/cloud/cloud.cfg

# 该配置默认为 false，修改为 true 即可
preserve_hostname: true
```

### 验证

```bash
root@kubernetes-master:~# hostnamectl
   Static hostname: kubernetes-master
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 33011e0a95094672b99a198eff07f652
           Boot ID: 8c0fd75d08c644abaad3df565e6e4cbd
    Virtualization: vmware
  Operating System: Ubuntu 18.04.2 LTS
            Kernel: Linux 4.15.0-48-generic
      Architecture: x86-64
```

