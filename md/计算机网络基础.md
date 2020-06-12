# 计算机网络基础

### 基础

- **TCP/IP四层协议**

  - 应用层          ```SMTP,FTP,HTTP,DND,TELNET,RPC等等```

  - 传输层          ```TCP,UDP```

  - 网络层          ```IP,ICMP,ARP,RAPP```

  - 网络接口     ```DATA LINK ```

    ![img](https://images2015.cnblogs.com/blog/764050/201509/764050-20150904095142060-1017190812.gif)

  ARP (**地址解析协议**) 

  ​		**根据[IP地址](https://baike.baidu.com/item/IP地址)获取[物理地址](https://baike.baidu.com/item/物理地址/2129)的一个[TCP/IP协议](https://baike.baidu.com/item/TCP%2FIP协议)。[主机](https://baike.baidu.com/item/主机/455151)发送信息时将包含目标IP地址的ARP请求广播到网络上的所有主机，并接收返回消息，以此确定目标的物理地址**

  RAPP(**逆地址解析协议**) 

  ​		**功能和ARP协议相对，其将局域网中某个主机的物理地址转换为IP地址**

  ---

  

+ **TCP的三次握手和四次挥手**

  ![img](https://images2015.cnblogs.com/blog/764050/201509/764050-20150904110008388-1768388886.gif)



+ **DNS协议**

  DNS是域名系统(DomainNameSystem)的缩写，该系统用于命名组织到域层次结构中的计算机和网络服务，**可以简单地理解为将URL转换为IP地址**。域名是由圆点分开一串单词或缩写组成的，每一个域名都对应一个惟一的IP地址，在Internet上域名与IP地址之间是一一对应的，DNS就是进行域名解析的服务器。DNS命名用于Internet等TCP/IP网络中，通过用户友好的名称查找计算机和服务。

+ **NAT协议**

  NAT网络地址转换(Network Address Translation)属接入广域网(WAN)技术，是一种将私有（保留）地址转化为合法IP地址的转换技术，它被广泛应用于各种类型Internet接入方式和各种类型的网络中。原因很简单，NAT不仅完美地解决了lP地址不足的问题，而且还能够有效地避免来自网络外部的攻击，隐藏并保护网络内部的计算机。

+ **DHCP协议**

  DHCP动态主机设置协议（Dynamic Host Configuration Protocol）是一个局域网的网络协议，使用UDP协议工作，主要有两个用途：给内部网络或网络服务供应商自动分配IP地址，给用户或者内部网络管理员作为对所有计算机作中央管理的手段。

---

+ **IP地址**
  + IP地址是一个32位的二进制数，通常被分割为4个“8位二进制数”（也就是4个字节）。IP地址通常用“点分十进制”表示成（a.b.c.d）的形式，其中，a,b,c,d都是0~255之间的十进制整数。

![ç½ç»å°åçåå](https://img-blog.csdn.net/20160712182446560)

+ **子网掩码**

  + 子网掩码(subnet mask)又叫网络掩码、地址掩码、子网络遮罩，它是一种用来指明一个IP地址的哪些位标识的是主机所在的子网，以及哪些位标识的是主机的位掩码。

    子网掩码不能单独存在，它必须结合IP地址一起使用。子网掩码只有一个作用，就是将某个IP地址划分成网络地址和主机地址两部分。 
    子网掩码是一个32位地址，用于屏蔽IP地址的一部分以区别网络标识和主机标识，并说明该IP地址是在局域网上，还是在远程网上。

  + 通过子网掩码，就可以判断两个IP在不在一个局域网内部。

  + 子网掩码可以看出有多少位是网络号，有多少位是主机号

    + IP地址二进制&子网掩码二进制 = 网络地址二进制 --->十进制
    + IP地址二进制&(~子网掩码二进制) = 主机地址
    
    

+ **路由选择协议**

​           常见的路由选择协议有：RIP协议、OSPF协议。

　　        **RIP协议** ：底层是贝尔曼福特算法，它选择路由的度量标准（metric)是跳数，最大跳数              是15跳，如果大于15跳，它就会丢弃数据包。

　　        **OSPF协议** ：Open Shortest Path First开放式最短路径优先，底层是迪杰斯特拉算法，  是链路状态路由选择协议，它选择路由的度量标准是带宽，延迟。

+ **路由器**

  + 路由器的实质是一种将网络进行互联的专用计算机，路由器在TCP/IP中又称为网关。

  + 下图是一个简单的的路由器结构

    ![img](http://image109.360doc.com/DownloadImg/2018/09/2817/145527554_2_20180928050311661)
    
    
    
    **NAT**
    
  + 示意图

    ![img](..\images\nat.jpg)

  + 特点:

    + 网络被分为私网和公网两个部分，NAT网关设置在私网到公网的路由出口位置，双向流量必须都要经过NAT网关;
    + **网络访问只能先由私网侧发起，公网无法主动访问私网主机；**
    + NAT网关在两个访问方向上完成两次地址的转换或翻译，出方向做源信息替换，入方向做目的信息替换；
    + NAT网关的存在对通信双方是保持透明的；
    + NAT网关为了实现双向翻译的功能，需要维护一张关联表，把会话的信息保存下来。

  + **静态NAT**

    + 如果一个内部主机唯一占用一个公网IP，这种方式被称为一对一模型。此种方式下，转换上层协议就是不必要的，因为一个公网IP就能唯一对应一个内部主机。显然，这种方式对节约公网IP没有太大意义，主要是为了实现一些特殊的组网需求。比如用户希望隐藏内部主机的真实IP，或者实现两个IP地址重叠网络的通信
      --------------------- 

    ​        ![img](..\images\snat.jpg)

  + **动态NAT**

    + 它能够将未注册的IP地址映射到注册IP地址池中的一个地址。不像使用静态NAT那样，你无需静态地配置路由器，使其将每个内部地址映射到一个外部地址，但必须有足够的公有因特网IP地址，让连接到因特网的主机都能够同时发送和接收分组

    ​      ![img](..\images\dnat.jpg)

  + NAT重载

    + 这是最常用的NAT类型。NAT重载也是动态NAT，它利用源端口将多个私网ip地址映射到一个公网ip地址(多对一)。那么，它的独特之处何在呢?它也被称为端口地址特换(PAT)。通过使用PAT(NAT重载)，只需使用一个公网ip地址，就可将数千名用户连接到因特网。其核心之处就在于利用端口号实现公网和私网的转换。 

      ![img](..\images\natoverload.jpg)

---

### 防火墙

+ 数据包在防火墙中的传递过程

  ![img](..\images\fw.png)

  1. 数据包抵达接口
  2. 匹配connection表项
  3. ACL检查
  4. 匹配地址转换
  5. 深度包检查
  6. IP头转换
  7. 抵达外出接口
  8. 3层路由表查找
  9. 2层mac地址查找
  10. 发送数据包

#### fortinet Configuring NAT

##### SNAT

![img](..\images\fortinetSNAT.png)

> Source Network Address Translation (SNAT) is an option available in Transparent mode and configurable in CLI only, using the following commands:

```fortran
config firewall ippool
	edit "nat-out"
        set endip 192.168.183.48
        set startip 192.168.183.48
        set interface vlan18_p3
	next
end

config firewall policy
	edit 3
        set srcintf "vlan160_p2"
        set dstintf "vlan18_p3"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set ippool enable
        set poolname "nat-out"
        set schedule "always"
        set service "ANY"
        set nat enable
	next
end
```

##### DNAT

> The following example shows how to configure Destination Network Address Translation (DNAT) using a virtual IP on a FortiGatein Transparent Mode:

```fortran
config firewall vip
    edit "vip1"
        set extip 192.168.183.48
        set extintf "vlan160_p2"
        set mappedip 192.168.182.78
	next
end

config firewall policy
	edit 4
        set srcintf "vlan160_p2"
        set dstintf "vlan18_p3"
        set srcaddr "all"
        set dstaddr "vip1"
        set action accept
        set schedule "always"
        set service "ANY"
	next
end
```

##### Static NAT

> In Static NAT one internal IP address is always mapped to the same public IP address.
>
> In FortiGate firewall configurations this is most commonly done with the use of Virtual IP addressing.
>
> An example would be if you had a small range of IP addresses assigned to you by your ISP and you wished to use one of those IP address exclusively for a particular server such as an email server.
>
> Say the internal address of the Email server was 192.168.12.25 and the Public IP address from your assigned addresses range from 256.16.32.65 to 256.16.32.127. Many readers will notice that because one of the numbers is above 255 that this is not a real Public IP address. The Address that you have assigned to the interface connected to your ISP is 256.16.32.66, with 256.16.32.65 being the remote gateway. You wish to use the address of 256.16.32.70 exclusively for your email server.
>
> When using a Virtual IP address you set the external IP address of 256.16.32.70 to map to 192.168.12.25. This means that any traffic being sent to the public address of 256.16.32.70 will be directed to the internal computer at the address of 192.168.12.25
>
> When using a Virtual IP address, this will have the added function that when ever traffic goes from 192.168.12.25 to the Internet it will appear to the recipient of that traffic at the other end as coming from 256.16.32.70.
>
> You should note that if you use Virtual IP addressing with the Port Forwarding enabled you do not get this reciprocal effect and must use IP pools to make sure that the outbound traffic uses the specified IP address.

#### JuniperSSG Configuring NAT

##### SNAT

juniper ssg 使用 dip 来进行 snat  

  命令：get dip all 可查看所有已定义的dip

![img](..\images\ssgSNAT.png)

dip 与接口绑定 ，设置接口时可以定义dip ，并且必须与接口ip在同一网段。DMZ 绑定的接口是 ethernet0/1,在开snat策略时 dip 必须是目的zone绑定接口的dip  

命令：

```shell
set interface ethernet0/1 dip 9 10.1.245.220 10.1.245.220  
```

```
set policy id 10029 name Trust_2_DMZ_8a515 from Trust to DMZ HOST-192.168.1.33_32 HOST-10.1.245.133_32 TELNET nat src dip-id 9  permit
```

##### DNAT

~~~fortran
set address Trust HOST-192.168.1.33_32 192.168.1.33/32   //源地址
set address DMZ HOST-10.1.245.133_32 10.1.245.133/32  //转换后的地址 (真实地址）
set address DMZ HOST-2.2.2.11_32 2.2.2.11/32  //转换前的地址
set route 2.2.2.11/32 int ethernet0/1    //必须加上路由  否则不通
set policy id 10025 name Trust_2_DMZ_b17ec from Trust to DMZ HOST-192.168.1.33_32 HOST-2.2.2.11_32 TELNET nat dst ip 10.1.245.133 permit
~~~



#### huawei usg Configuring NAT

##### Static NAT (1对1)

使用static nat 来进行目的地址转换

设备：cisco asa 192.168.1.204

接口：![img](..\images\image2020-3-17_16-55-19.png)

![img](..\images\image2020-3-17_16-55-31.png)

设备:huawei usg 192.168.1.205

接口：![img](..\images\image2020-3-17_16-57-38.png)

拓扑：![img](..\images\image2020-3-17_16-58-8.png)

```shell
security-policy
rule name untrust_2_dmz_c0dbd
description create by NAP 97e5819c-2c2c-435b-9e29-5e40d8715f9a
source-zone untrust
destination-zone dmz
source-address address-set WS_172.16.205.1_32
destination-address address-set ws_10.1.206.1
service Any
action permit
```

~~~
nat server untrust_2_dmz_b9fe1 global 12.1.214.33 inside 10.1.206.1
~~~

cisco设备上设置路由:

![img](..\images\image2020-3-17_17-1-37.png)

在cisco上ping 12.1.214.33

转换结果

![img](..\images\image2020-3-17_17-4-35.png)



##### Source NAT

源NAT策略用于实现内网主机使用私网地址访问Internet。系统会将内网主机报文的源IP由私网地址转换为公网地址。在配置时，转换前的源地址应选择私网地址或地址组（可多选），转换后的源地址可以使用NAT地址池或使用报文出接口的公网IP地址。

```
nat-policy
[USG6000V2-policy-nat]
rule name snat1
[USG6000V2-policy-nat-rule-snat1]
description test
[USG6000V2-policy-nat-rule-snat1]
destination-zone untrust
[USG6000V2-policy-nat-rule-snat1]
source-zone trust
[USG6000V2-policy-nat-rule-snat1]
source-address address-set WS_192.168.1.11_32
[USG6000V2-policy-nat-rule-snat1]
destination-address address-set WS_2.3.1.120_32
[USG6000V2-policy-nat-rule-snat1]
service TCP_241
[USG6000V2-policy-nat-rule-snat1]
action nat address-group test2            //test2为地址池里面的地址
[USG6000V2-policy-nat-rule-snat1]
```



##### Destination NAT

![img](..\images\image2020-2-28_16-17-37.png)


  


  