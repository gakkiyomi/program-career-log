# NMAP

>NMAP (Network Mapper) 是一款基于 GNU GPLv2 的 License (Nmap Public Source License Version 0.92)的开源软件，使用 C 语言和 Lua 语言编写，一般用于网络发现和安全审核。许多系统和网络管理员还使用它进行管理服务升级计划以及监视主机或服务是否正常运行。
>
>黑客也使用 namp 进行漏洞扫描从而计划攻击的方法。Nmap 以新颖的方式使用原始 IP 数据包来确定网络上可用的主机，以及这些主机提供的服务（应用程序名称和版本），它们正在运行的操作系统（和 OS 版本）等。
>
>它旨在快速扫描大型网络，也可以在单个主机上正常运行。
>
>Nmap 可在所有主流的计算机操作系统上运行，官方二进制软件包可用于 Linux，Windows 和 Mac OSX。



Nmap主要包括四个方面的扫描功能，**主机发现**、**端口扫描**、**应用与版本侦测**、**操作系统侦测**。



### 主机发现

主机发现**(Host Discovery)**即用于发现目标主机是否被占用。

默认情况下，Nmap会发送四种不同类型的数据包来探测目标主机是否在线。

1. ICMP echo request
2. a TCP SYN packet to port 80
3. a TCP ACK packet to port 80
4. an ICMP timestamp request

依次发送四个报文探测目标机是否开启。只要收到其中一个包的回复，那就证明目标机开启。使用四种不同类型的数据包可以避免因防火墙或丢包造成的判断错误。

通过上面可知在实际主机发现过程中，根据协议的不同，可以分为已下两种方式：

+ **利用二层协议 **
  + 在二层中也就是不经过路由器在同一网段下，使用**ARP**协议枚举扫描网段下的ip收到arp的回包可以知道目标主机是否处于活跃状态。
  + **PING扫描** 发送ICMP数据包，将做出响应的主机处于活跃状态。
+ 利用三层协议
  + **TCP协议：**利用TCP三次握手中的第一次握手与第二次握手。让对方觉得正在试图建立一个TCP连接，从而做出回应，根据回应得出主机状态。
  + **UDP协议：**则是发送一个UDP数据包，得到端口不可达、主机网络不可达的回应。

ARP扫描是最精准的扫描方式，并且不会被过滤，但是只能才同一网段下使用。ICMP扫描是最常见的扫描方式，和ping命令原理一致，但可能被防火墙拦截，使得ICMP主机发现失败。端口扫描技术是另一种发现主机的方式，准确且不容易被防火墙过滤，这种方式被经常使用。

值得注意的是：

**如果在同一网段，则无论主机发现参数如何指定，Nmap都使用ARP扫描完成主机发现。**



| **参数**        | **描述**                                                     | **是否常用** |
| --------------- | ------------------------------------------------------------ | ------------ |
| -sL             | 仅列出指定参数有哪些IP，并反向查询域名信息。                 | 一般         |
| -sn             | 只单独进行主机发现过程 ,默认的主机发现方式。                 | 常用         |
| -Pn             | 不进行主机发现，直接进入端口扫描阶段，能绕过ICMP过滤，老版本为-P0。 | 常用         |
| -PS/-PA/-PU/-PY | 分别用TCP SYN/TCP ACK/UDP/SCTP技术进行主机发现。             | 常用         |
| -PE/-PP/-PM     | 分别用ICMP ECHO/ICMP TIMESTAMP/ICMP MASK技术进行主机发现。   | 一般         |
| -PO             | 使用参数指定的协议（如TCP）对主机进行扫描。                  | 不常用       |

#### ARP 扫描

Nmap 所在的机器会向整个网段广播 arp 包，如果收到回包则说明该 ip 地址处于活跃状态。但是 arp 是二层协议，无法扫描不同 vlan 不同网段的主机。

#### Ping 扫描

ping 扫描使用 arp 协议结合三层路由协议向不同 vlan 不同广播域发送 icmp 报文，根据 icmp 的响应报文判断主机是否可达。

-sn Ping Scan 只进行主机发现，不进行端口扫描。

nmap -sn -T4 --packet-trace 192.168.1.146

![image.png](https://b3logfile.com/file/2020/10/image-d75ea40e.png?imageView2/2/w/1280/format/jpg/interlace/1/q/100)

#### TCP/UDP 扫描

TCP 主机发现是基于 TCP 三次握手，尝试发送一个 TCP SYN 包，收到回包就证明目标机处于活跃状态。详情见端口扫描。



### 端口扫描

端口扫描**(Port Scanning)**是namp最核心的功能，用于确定主机目标的TCP/UDP端口开放情况。默认情况下，Nmap会扫描1000个最有可能开放的TCP端口。

- open：端口是开放的。
- closed：端口是关闭的。
- filtered：端口被防火墙IDS/IPS屏蔽，无法确定其状态。
- unfiltered：端口没有被屏蔽，但是否开放需要进一步确定。
-  open | filtered : 端口是开放的或被屏蔽。
-  closed| filtered : 端口是关闭的或被屏蔽。

Nmap在端口扫描方面非常强大，提供了十多种探测方式。



#### TCP SYN scanning

SYN scanning 是Nmap默认的扫描方式，被称作半开放扫描（**Half-open scanning**）。发送SYN到目标端口，如果收到SYN/ACK回复，那么判断端口是开放的；如果收到RST包，则说明该端口是关闭的。如果没有收到回复，那么就判断该端口被屏蔽（Filtered）。因为该方式仅发送SYN包对目标主机的特定端口，但不建立的完整的TCP连接，所以相对于其他方式比较隐蔽，并且效率较高，适用范围广。



-sS: 指定使用 TCP SYN的方式来对目标主机进行扫描。



TCP SYN 检测到端口关闭：![image.png](https://b3logfile.com/file/2020/10/image-732a0beb.png)

TCP SYN 检测到端口开放：![image.png](https://b3logfile.com/file/2020/10/image-1cc33358.png)

#### TCP connect scanning

TCP connect方式使用系统网络API connect向目标主机的端口发起连接，如果无法连接，说明该端口关闭。该方式扫描速度比较慢，而且由于建立完整的TCP连接会在目标机上留下记录信息，不够隐蔽。所以，TCP connect是TCP SYN无法使用才考虑选择的方式。



-sT :指定使用 TCP Connect 的方式来对目标主机进行扫描。



TCP connect 检测到端口关闭：![image.png](https://b3logfile.com/file/2020/10/image-c153ba3d.png)



TCP connect 检测到端口开放：![image.png](https://b3logfile.com/file/2020/10/image-82d0de46.png)



#### TCP ACK scanning

向目标主机的端口发送ACK包，如果收到RST包，说明该端口没有被防火墙屏蔽；没有收到RST包，说明被屏蔽。**该方式只能用于确定防火墙是否屏蔽某个端口，可以辅助TCP SYN的方式来判断目标主机防火墙的状况。**



-sA: 指定使用 TCPACK的方式来对目标主机进行扫描。



TCP ACK 探测到端口被屏蔽：![image.png](https://b3logfile.com/file/2020/10/image-a84b26b9.png)

TCP ACK 探测到端口未被屏蔽：![image.png](https://b3logfile.com/file/2020/10/image-ffb5267b.png)



#### TCP FIN/Xmas/NULL scanning

这三种扫描方式被称为秘密扫描（Stealthy Scan），因为相对比较隐蔽。FIN扫描向目标主机的端口发送的TCP FIN包或Xmas tree包/Null包，如果收到对方RST回复包，那么说明该端口是关闭的；没有收到RST包说明端口可能是开放的或被屏蔽的（open  filtered）。

其中Xmas tree包是指flags中FIN URG PUSH被置为1的TCP包；NULL包是指所有flags都为0的TCP包。



1. -sN/sF/sX: 指定使用TCP Null, FIN, and Xmas scans秘密扫描方式来协助探测对方的TCP端口状态。

2. --scanflags <flags>: 定制TCP包的flags。

TCP FIN 探测到端口关闭：![image.png](https://b3logfile.com/file/2020/10/image-0fe50000.png)

TCP FIN探测到端口开放/被屏蔽![image.png](https://b3logfile.com/file/2020/10/image-4823e190.png)

#### UDP scanning

UDP扫描方式用于判断UDP端口的情况。向目标主机的UDP端口发送探测包，如果收到回复“ICMP port unreachable”就说明该端口是关闭的；如果没有收到回复，那说明UDP端口可能是开放的或屏蔽的。因此，通过反向排除法的方式来断定哪些UDP端口是可能出于开放状态。



1. -sU: 指定使用UDP扫描方式确定目标主机的UDP端口状况。



UDP端口关闭：![image.png](https://b3logfile.com/file/2020/10/image-5c280242.png)

UDP端口开放/被屏蔽：![image.png](https://b3logfile.com/file/2020/10/image-b9b4a7aa.png)

- 其他方式

除上述几种常用的方式之外，Nmap还支持多种其他探测方式。例如使用SCTP INIT/COOKIE-ECHO方式来探测SCTP的端口开放情况；使用IP protocol方式来探测目标主机支持的协议类型（TCP/UDP/ICMP/SCTP等等）；使用idle scan方式借助僵尸主机（zombie host，也被称为idle host，该主机处于空闲状态并且它的IPID方式为递增。或者使用FTP bounce scan，借助FTP允许的代理服务扫描其他的主机，同样达到隐藏自己的身份的目的。



4. -sI <zombiehost[:probeport]>: 指定使用idle scan方式来扫描目标主机（前提需要找到合适的zombie host）
5. -sY/sZ: 使用SCTP INIT/COOKIE-ECHO来扫描SCTP协议端口的开放的情况。
6. -sO: 使用IP protocol 扫描确定目标机支持的协议类型。







### 版本侦测

nmap提供了确定目标主机开放端口上运行的具体程序信息和版本信息**（Version Detection）**。

nmap内置了广泛的应用程序数据库(**nmap-services-probes**) ,目前Nmap可以识别几千种服务的签名，包含了180多种不同的协议。



-sV:开启端口服务版本探测



原理:

 	1. 先检查端口是否open
 	2. 如果是TCP端口，就尝试建立TCP连接,通常在等待时间内会接收到目标机器发送的“WelcomeBanner”信息。nmap将接收到的Banner与**nmap-services-probes**中NULL probe中的签名进行对比。查找对应应用程序的名字与版本信息。

3. 如果通过“Welcome Banner”无法确定应用程序版本，那么nmap再尝试发送其他的探测包（即从nmap-services-probes中挑选合适的probe），将probe得到回复包与数据库中的签名进行对比。如果反复探测都无法得出具体应用，那么打印出应用返回报文，让用户自行进一步判定。

4. 如果是UDP端口，那么直接使用nmap-services-probes中探测包进行探测匹配。根据结果对比分析出UDP应用服务类型。
5. 如果探测到应用程序是SSL，那么调用openSSL进一步的侦查运行在SSL之上的具体的应用类型。

6. 如果探测到应用程序是SunRPC，那么调用brute-force RPC grinder进一步探测具体服务。

### 操作系统侦测

操作系统侦测**(Operating System Detection)**用于检测目标主机运行的操作系统类型及设备类型等信息。

os侦测返回的是推断为可能的操作系统列表



-O:开启操作系统探测

1. --osscan-limit: 限制Nmap只对确定的主机的进行OS探测（至少需确知该主机分别有一个open和closed的端口）。  
2. --osscan-guess: 大胆猜测对方的主机的系统类型。由此准确性会下降不少，但会尽可能多为用户提供潜在的操作系统。 



Nmap拥有丰富的系统数据库nmap-os-db，目前可以识别2600多种操作系统与设备类型。

1. Nmap内部包含了2600多已知系统的指纹特征（在文件nmap-os-db文件中）。将此指纹数据库作为进行指纹对比的样本库。
2. 分别挑选一个open和closed的端口，向其发送经过精心设计的TCP/UDP/ICMP数据包，根据返回的数据包生成一份系统指纹。
3. 将探测生成的指纹与nmap-os-db中指纹进行对比，查找匹配的系统。如果无法匹配，以概率形式列举出可能的系统。



### 脚本

nmap支持使用lua语言来为nmap进行脚本开发。使用Python或者其他语言来调用Nmap进行格式解析，这种方式无法预估扫描进度，不能进行状态交互，效率很差，如果有需要我们可以自己编写定制化的的Nmap脚本。

**脚本分类**

- auth 处理身份验证
- broadcast 网络广播
- brute 暴力猜解
- default 默认
- discovery 服务发现
- dos 拒绝服务
- exploit 漏洞利用
- external 外部扩展
- fuzzer 模糊测试
- intrusive 扫描可能造成不良后果
- malware 检测后门
- safe 扫描危害较小
- version 版本识别
- vuln 漏洞检测

这些脚本nmap都内置在安装目录的script目录里面

### 漏洞扫描

nmap 内置了一个**vuln**分类支持漏洞扫描如果想要使用这个分类下的所有脚本，可以在--script的后面加上分类名称，同样我们可以用相似的方法来提高目标版本的检测功能，以及将目标端口设置为全部有效端口。

~~~go
nmap -p- -sV --version-all --script vuln 192.168.1.146
~~~

-p- 指的是将目标端口指定为全部有效端口， -sV --version-all 用来提高版本检测的效率。

也可以指定详细的某个漏洞类型，如果填--script=vuln 则扫描所有漏洞库

```
nmap --script http-slowloris-check  192.168.1.146
```

下图是在146上扫描出端口为8080的服务也就是keycloak的一个漏洞

测试Web服务器是否受到Slowloris DoS攻击的漏洞，而无需实际发起DoS攻击。

![image.png](https://b3logfile.com/file/2020/10/image-37c9c31d.png)

![image.png](https://b3logfile.com/file/2020/10/image-0b152be7.png)



更多漏洞扫描脚本详情  https://nmap.org/nsedoc/categories/vuln.html 

**Vulscan，它是Nmap的一个第三方漏洞扫描增强模块，通过它可以把Nmap打造成一款实用高效免费的漏洞扫描器。Vulscan目前包含了CVE、OSVDB、Exploit-db、openvas等多个漏洞平台指纹数据，具备离线扫描功能，对主机系统漏洞有很好的探测识别效果。**

文档: https://www.freebuf.com/sectool/144821.html