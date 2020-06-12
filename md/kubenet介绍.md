### k8s架构

源于google内部的borg，提供了面向应用的容器集群部署和管理系统。k8s的目标旨在消除编排物理/虚拟运算，网络和存储基础设施的符单，并使应用程序运营商和开发人员完全将重点放在以容器为中心的原语上进行自助运营。（具备完善的集群管理能力）

k8s具备完善的集群管理能力，包括多层次的安全防护准入机制、多租户应用支撑能力、透明的服务注册和服务发现机制、内建服务均衡器、故障发现和自我修复能力、服务滚动升级和在线扩容、可扩展的资源自动调度机制、多粒度的资源配额管理能力

### 基本概念

kubenetes主要有以下几个核心组件组成：
* etcd保存了整个集群的状态
* kube-apiserver提供了资源操作的唯一入口，并提供认证、授权、访问控制、api注册和发现等机制
* kube-controller-manager负责维护集群的状态，比如故障检测、自动扩展、滚动更新等
* kube-scheduler负责资源的调度，按照预定的调度策略将pod调度到响应的机器上；
* kubelet负责维持容器的生命周期，同时也负责volume（CVI）和网络（CNI）的管理
* Container runtime负责镜像管理以及pod和容器的真正运行（CRI），默认的容器运行时为docker
* kube-proxy负责为service提供cluster内部的服务发现和负载均衡(代理节点)

>看视频复习，讲架构图

kubeproxy:iptables/ipvs/userspace

CRI:docker/rkt

CNI:calico/flannel/weave

kubenetes还有一些add-on：
* kube-dns负责为整个集群提供dns服务(不管ip怎么变，服务名不变)
* ingress controller为服务提供外网入口
* heapster提供资源监控
* dashboard提供gui
* federation提供跨可用区的集群
* fluentd-elasticsearch提供集群日志采集、存储与查询

### k8s术语介绍

1. Container

优点：敏捷开发，持续开发，可观测，松隅合，微服务，资源隔离

2. Pod

k8s是k8s里最小的单位，k8s使用pod来管理容器

pod是一组紧密关联的容器集合，他们共享pid，ipc，network和uts namespace，k8s调度的最小单位。pod被多个容器共享网络和文件系统，可以通过进程间通信和文件共享这种简单高效的方式组合完成服务

3. Master

k8s的控制器，包括api-server，调度器scheduler和控制器管理器controller-manager。主要负责全局的，集群级的pod调度和时间处理。通常所有的主组件都是建立在单个主机上的。当考虑高可用性场景或非常大的集群时，希望拥有主冗余

4. node

node是pod真正运行的主机，为了管理pod，每个node节点上至少要与运行container runtime、kubelet和kubeproxy服务

5. namespace

是对一组资源和对象的抽象集合，比如可以用来将系统内部的对象划分为不同的项目组或用户组(命名空间)，常见的pods,services,replication controllers和deployments都是某一个namespace

6. Service

每个service都会自动分配一个cluster ip和dns。

7. label

识别k8s的标签，以key/value的方式附加到对象上(键值对)，用来组合一组对象，通常是pod。

labels不提供唯一性，并且实际上经常是很多对象都使用相同的label来标志具体的应用

8. label selector
9. annotations 用来记录一些附加信息
10. 集群