### pod

1. 运行一个pod
```
kubectl run db --image mongo

```

2. 查看信息
```
kubectl get pods
```

3. 删除pod
```
kubectl delete development db
```

4. 通过声明语法创建
```
kubectl create -f pod/db.yml

kubectl get pods -o json # 以json格式显示(或wide)

kubectl describe pod db
```

5. 流程
```
kubectl发布请求创建pod - apiserver发出请求 - scheduler调取信息 - 在指定node节点运行pod - 返回到apiserver节点 - apiserver发布信息到kubelet - kubelet向docker请求创建容器 - kubelet更新状态 
```

6. 在一个pod里运行多个容器
```
在声明文件中写入两个容器

kubectl exec -it -c api go-demo-2 ps aux # 现在pod里有两个容器，需要指定容器去查看

```

### ReplicaSets 控制器

>大多数应用程序都应该是可伸缩的，所有的应用程序都必须具有容错能力。Pods不提供这些特性，ReplicaSets就可以做到

Replication Controller的主要功能只是确保一个特定数量的pod副本与实际状态一致

声明：
```
replicas 运行复制的个数
```

1. 创建一个复制器
```
kubectl create -f rs/go-demo-2.yml
kubectl get rs
kubectl get pods --show-labels
```
2. 流程
```
kubectl发布请求 - apiserver 发布请求 - rs controller 收到请求- 通过apiserver去发布 - Scheduler 调度一个节点去发布pod - kubelet通过apiserver收到请求 - 请求docker去创建容器 - kubelet通过apiserver更新状态
```
3. 操作
```
# 只删除复制控制器
kubectl delete -f rs/go-demo-2.yml --cascade=false

# 扩展新副本，旧副本保持不变
kubectl apply -f rs/go-demo-2-scaled.yml

# 删除一个pod，新创建一个
POD_NAME=$(kubectl get pods -o name |tail -1)
kubectl delete $POD_NAME
```
复制控制器是通过选择器里的label标签去管理pod

### Service

只有在建立了通信路径之后，应用程序才能完成它们的角色。

k8s的服务提供了可以访问关联pod的地址

1. 通过公共端口创建服务
```
kubectl create -f svc/go-demo-2-rs.yml
kubectl get -f svc/go-demo-2-rs.yml
kubectl expose rs go-demo-2 --name=go-demo-2-svc --target-port=28017 --type=NodePort
```
2. 流程
```
kubectl发送请求 - apiserver收到 - apiserver发送请求到Endpoint Controller - E C创建一个端点对象 - apiserver通知kube proxy更新iptables - apiserver通知kube DNS增加解析
```
3. 声明式语法
```
type:NodePort
nodePort # node节点上的端口
protocol # 协议
selector # 选择器
```
4. 服务发现
```
主要通过两种主要模式来发现:环境变量和DNS
每一个pod都为每一个活跃的服务来获取环境变量

kubectl exec $POD_NAME env

首先检查本地dns解析地址 - 如果没有就使用kube-dns - 如果没有就通过iptables规则 - 最后找到
```
5. selector
```
selector会为Service指派以一个Endpoint对象
如果不指定selector，就不会创建相关的Endpoints对象。可以手动将Service映射到指定的Endpoints。
如果后续决定要将数据库迁移到Kubetnetes中，可以启动对应的Pod，增加合适的Selector或Endpoint，修改service的type。
```
### Development

我们必须在开发和测试的时候将特性发布到生产环境中，频繁发布的需求增强了对零停机部署的需求。Kubenetes提供Development在没有停机的情况下部署。

1. 部署一个新版本

声明文件
```
Kind： Development
```
和replica差不多

```
kubectl create -f deploy/go-demo-2.yml
```
执行之后development使用replicaSets去创建容器

流程:
```
kubectl发布事件到api，development收到对象事件后创建一个replicaSets对象，将事件发送到api，replicaSets接受到事件后，创建并继续创建pod对象，然后调度器对指定pod到指定节点上，kubelet监听到需要创建pod，这时候就会向docker去请求创建容器，并且更新pod的状态
```
2. 更新部署

```
kubectl set image -f deploy/go-demo-2-db.yml db=mongo:3.4 --record
```
使用set image来更新，保持旧的控制器不变，创建一个新的控制器。
```
kubectl edit -f deploy/go-demo-2-db.yml
```
这时候就可以更改配置文件中的内容，更新部署的内容

```
--save-config 保存配置

--record 保存记录
```

3. 零宕机部署

实际应用中对于当一副本无法进行高可用
```
minReadySeconds 默认值为0，这意味着一旦准备就绪，Pods就认为是可用的

progressDeadlineSeconds 部署等待时间（超过等待时间则部署失败）

revisionHistoryLimit 可以回滚的旧复制的数量，默认为10

Recreate 在更新之前，杀死所有现在的pod，比较适合单副本数据库

RollingUpdate 默认策略，允许我们没有停机时间的情况下部署新版本(maxSurge 定义超出需要本批次更新运行的数量，数字或百分比  maxUnavailable 定义了不能使用的最大数量，也就是更新时，要停掉多少正在允许的pod，默认是25%)
使用这个策略的pod是一个一个增加，旧pod一个一个减少，当增加的pod超过限定值，就使用新的pod
```

```
kubectl create -f deploy/go-demo-2-api.yml --record
```
```
kubectl set image -f deploy/go-demo-2-api.yml api=vfarcic/go-demo-2:2.0 --record
```

```
kubectl rollout status -w -f deploy/go-demo-2-api.yml

kubectl rollout history -w -f deploy/go-demo-2-api.yml 
```

4. 滚动更新
```
kubectl rollout undo -f deploy/go-demo-2-api.yml 回滚，撤销，恢复到上一个版本

kubectl rollout history -f deploy/go-demo-2-api.yml

kubectl rollout undo -f deploy/go-demo-2-api.yml --to-revision=2 回滚到2版本
```

### Ingress

ingress对象管理对运行在k8s集群内的应用程序的外部访问，提供了一个api允许每个程序通过一个不同的端口到达。类似于nginx

每次去访问docker应用，都要去查询端口，十分麻烦，使用ingress，使用一个端口来代理端口。

请求
```
ingress-nginx(service request) ->  ingress controller -> ingress -> service -> pod
```
ingress定义：
1. 在同一namespace下
2. 创建控制器
3. 创建ingress资源
* 基于路径：- path:/demo 
* 基于域名：- host: nginx 
>都使用http:path -backend来定义
```
backend: serviceName: demo servicePort:80
```
4. Service指定结点


>namespace的查看 -n

流程：
```
apiserver ->create ingress -> ingress Controller 查找ingress资源 ->配置ingress资源规则(路径/域名)
```

>ingress controller会将一个ingress对象加载生成一段nginx配置，然后将配置通过kubenetes api写到nginx的pod中，然后reload

### 卷

卷：一个pod容器所访问的文件和目录的引用

可以处理有状态应用

比如运行一个docker容器，可以挂载本地的docker socket，这样在容器中运行的docker命令就是操作本机的docker了
```
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-socker
  volumes:
  - name: docker-socket
    hostpath:
      path: /var/run/docker.sock
      type: Socket
```
当我们有一个配置文件，也可以将配置文件的路径对应到pod中，这样容器就会直接执行配置文件的配置。
>/etc/redis,则会将redis文件夹放入，/etc/redis/，则会将redis文件夹中所有文件放入

通过空白卷来保持持久状态,创建空白卷之后会创建一个空白卷来保持状态(伴随pod)
```
    volumeMounts:
    - mountPath: /var/jenkins-home
      name: jenkins-home
  volumes:
  - emptyDir: {}
    name: jenkins-home
```

### Configmaps

configmaps允许将配置和应用程序映像分开，配置文件的来源可以是文件，目录或文字值，目标可以是文件或者环境变量

configmap从一个源获得一个配置，并将其安装到运行容器中作为一个卷

创建方式：
1. 通过yaml文件
* 参数采用k/v
* 文件采用file: |[file]
2. 通过kubectl直接在命令行下创建，直接将一个配置文件创建为一个configMap，通过在命令行直接传递键值对创建：
* kubectl create configmap test-config3 --from-file=./configs/db.conf --from-literal=db.host=10.5.10.116 --from-listeral=db.port='3306'

使用方法：
1. 直接传递pod
```
env:
    - name: SPECIAL_LEVEL_KEY
      valueFrom:
        configMapKeyRef:
          name: special-config
          key: special.how
    - name: SPECIAL_TYPE_KEY
      valueFrom:
        configMapKeyRef:
          name: special-config
          key: special.type
```
2. 在命令行下引用
```
  command: [ "/bin/sh", "-c", "echo $(SPECIAL_LEVEL_KEY) $(SPECIAL_TYPE_KEY)" ]
  env:
    - name: SPECIAL_LEVEL_KEY
      valueFrom:
        configMapKeyRef:
          name: special-config
          key: special.how
    - name: SPECIAL_TYPE_KEY
      valueFrom:
        configMapKeyRef:
          name: special-config
          key: special.type
```
3. 使用volume将ConfigMap作为文件或目录直接挂载，其中每一个key-value键值对都会生成一个文件，key为文件名，value为内容
```
    volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: special-config
```

### Secret

敏感数据需要额外处理，K8S通过secret提供额外保护等级。

pod有两种方式来使用secret：
* 作为volume的一个域被一个或多个容器挂载
* 在拉取镜像的时候被kubelet引用。

1. 內建的Secrets：

由ServiceAccount创建的API证书附加的秘钥

k8s自动生成的用来访问apiserver的Secret，所有Pod会默认使用这个Secret与apiserver通信

2. 自己的Secret
```
kubectl create secret generic db-user-pass --from-file=./username.txt --from-file=./password.txt
```
或者用yaml文件
```
$ echo -n 'admin' | base64
YWRtaW4=
$ echo -n '1f2d1e2e67df' | base64
MWYyZDFlMmU2N2Rm

apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm
```

使用
```
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
      readOnly: true
  volumes:
  - name: foo
    secret:
      secretName: mysecret
```