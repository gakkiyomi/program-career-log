# SNMP

> SNMP (simple network mangment protocol)简单网络管理协议，是为了应对如防火墙，路由器，交换机，F5 或者服务器甚至 PC 等品种繁多的网络设备而产生的一种通用协议。

### 介绍

设备中有许多基本信息，比如接口，主机名，ip 等，这些信息我们都可以使用 snmp 获取。那么在 snmp 中这些信息应该怎么被我们有规则的检索到呢？这时候就用到了 MIB 了，任何一个被管理的资源都表示成一个对象，称为被管理的对象。MIB 是被管理对象的集合。它定义了被管理对象的一系列属性：对象的名称、对象的访问权限和对象的数据类型等。每个 **SNMP** 设备（Agent）都有自己的 MIB。

我们可以通过**对象标识**来检索 MIB 数据库获得我们想要的信息。对象标识是一个整数序列，以点（.）分割，这些整数构成了一个树状结构，类似于 DNS 或者 Unix 的文件系统，对象标识从树的顶部开始，顶部没有标识。树上的每个节点同时还有一个文件名，为了方便阅读，MIB 变量名是以对象标识来标识的，都是以 1.3.6.1.2.1 开头，如下图：

![image.png](https://b3logfile.com/file/2020/09/image-29b2bc81.png?imageView2/2/interlace/1/format/webp)



也就是说我们只要知道我们所需要信息的对象标识，就可以通过 snmp 获取。

### SNMP 报文

SNMP 定义了

1. get 从代理进程提取一个或者多个参数值
2. get-next 获取一个或者多个参数的下一个参数值
3. set 设置代理进程的一个或者多个参数值
4. get-response 获取前三个操作的响应
5. trap 由代理主动进行推送的报文，通知事件发生，可预定触发的阈值

SNMP 往往使用 UDP 协议，默认端口 161

![image.png](https://b3logfile.com/file/2020/09/image-add90157.png?imageView2/2/interlace/1/format/webp)



![image.png](https://b3logfile.com/file/2020/09/image-4cae5673.png?imageView2/2/interlace/1/format/webp)





![image.png](https://b3logfile.com/file/2020/09/image-0fffdf20.png?imageView2/2/interlace/1/format/webp)



### CentOS 下安装 SNMP

使用 yum 安装

```bash
yum install -y net-snmp net-snmp-utils
```

启动 snmp

```bash
service snmpd start
```

### 关于 public 只能获取 system 信息的问题

打开 snmp 配置文件

```bash
vim /etc/snmp/snmpd.conf
```

如果想获取 ip 或者其他信息的话需要进行配置，CentOS 只允许查看系统信息，请注释掉一下两行，在加上一行允许 查看 .1 后面的所有节点信息。

```bash
#view    systemview    included   .1.3.6.1.2.1.1
#view    systemview    included   .1.3.6.1.2.1.25.1.1
view    systemview   included  .1
rocommunity public default
```

重启 snmp

```bash
systemctl restart snmpd
```

### example

通过 snmp 获取主机名，通过谷歌可知 oid 为 1.3.6.1.2.1.1.5

可以通过 snmp 的 get 命令或者 walk 命令获取

```bash
snmpwalk -c public -v 2c -m ALL localhost .1.3.6.1.2.1.1.5
```

~~~shell
snmpget -c public -v 2c -m ALL localhost .1.3.6.1.2.1.1.5.0
~~~

如果请求的数据有多个 比如有多个接口请使用 walk 命令

下图是 windows 下的命令，需要下载工具 snmputil

[snmputiljb51.rar](https://b3logfile.com/file/2020/09/snmputiljb51-6ac0f6c5.rar)

![image.png](https://b3logfile.com/file/2020/09/image-82e307c8.png?imageView2/2/interlace/1/format/webp)