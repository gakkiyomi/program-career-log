# JuniperSSG 防火墙概览

juniperSSG 只能通过获取所有配置进行解析,不像fortinet可以拆分命令进行解析

​	通过get xxx 来获取配置信息  但这些信息不能解析

##### 获取所有配置

~~~shell
ssg245-> get confg all   //解析这个

~~~

##### save命令进行持久化

~~~
ssg245->save
~~~

##### hostname

~~~shell
ssg245-> set hostname xxx
~~~

##### zone

创建一个zone,若是Layer2Zone 则需要L2-开头

~~~shell
ssg245-> set zone name L2-abc L2   
~~~

若是tunnel类型 需要指定 tunnel out zone's name

~~~
ssg245-> set zone name ggg tunnel Trust
~~~

修改zone

~~~shell
ssg245->set zone zonename
~~~



##### interface

​	interface 在配置ip前必须先配置zone

~~~shell
ssg245-> set interface ethernet0/2 zone Trust //设置zone 不设置的话没有设置ip的选项
ssg245-> set interface ethernet0/1 ip 1.1.1.1/24
~~~

##### address

在指定的zone创建一个address   名字唯一 

~~~shell
ssg245-> set address Trust addressName 1.2.3.4/24 desc  //ipv4
~~~

~~~
ssg245-> set address Trust addressName domainName desc  //domain 使用 get domian 获得
~~~

##### address group

 指定zone 创建一个address group    名字唯一  

~~~
ssg245->set group address Trust addrgr1
~~~

修改

~~~
ssg245->set group address Trust addrgr1 add aa comment desc //增加member 必须是此zone内的地址
ssg245-> set group address Trust addrgr1 comment desc  //只comment
ssg245-> set group address Trust addrgr1 hidden //hidden group
~~~

##### service 

***获取预定义的service对象***     不能通过get config all 获取 所以暂时无法解析 

~~~
ssg245-> get service pre-defined
~~~

名字唯一  插入一个service

~~~
ssg245->set service serv1 protocal <num> src-port 11-22 dst-port 33-44 timeout60/never
ssg245->set service serv2 protocal tcp src-port 11-22 dst-port 33-44 timeout60/never
ssg245->set service serv3 protocal udp src-port 11-22 dst-port 33-44 timeout60/never
ssg245-> set service ab protocol sun-rpc program 1-3 timeout60/never
ssg245-> set service ab2 protocol ms-rpc uuid xxx-xxx-xxx-xxxx //uuid
~~~

修改 将protocal改成+   icmp/tcp/udp/udp可看做同一类型 sun-rpc, ms-rpc 不同类型不能尾加

~~~
ssg245->set service serv1 + <num> src-port 11-22 dst-port 33-44 timeout60/never
~~~

##### service group 

  创建一个service group    名字唯一  

~~~
ssg245-> set group service g1 
~~~

修改 与address group 雷同  使用add

~~~
ssg245->set group service g1 add aa comment desc //增加member 
ssg245-> set group service g1 comment desc  //只comment
ssg245-> set group service g1 hidden //hidden group
~~~

##### scheduler

有once 和 Recurrent 两种类型

~~~
ssg245-> set scheduler b once start mm/dd/yyyy hh:mm stop mm/dd/yyyy hh:mm comment desc
~~~

Recurrent 可设置两个时间

~~~
ssg245-> set scheduler abc recurrent monday start 11:22 stop 22:21 start 22:11 stop 11:23
~~~

##### syslog

~~~
ssg245-> set syslog config 1.2.3.4/24 //ip
ssg245-> set syslog config ssg245  //hostname
~~~

##### policy

可以直接设置   指定zone到zone   id唯一

~~~
ssg245-> set policy from ZoneName to ZoneName Any Any ANY dney
ssg245-> set policy global Any Any ANY dney    //golbal policy
~~~

先根据id进入指定的policy进行设置

~~~
ssg245-> set policy id 125 
ssg245(policy:125)-> 
---------------------
ssg245(policy:125)-> set src-address abb  //源地址    可以多个
ssg245(policy:125)-> set dst-address abb2 //目的地址  可以多个
ssg245(policy:125)-> set service ser //服务   可以多个
~~~

#### JuniperSSG Configuring NAT

##### SNAT

juniper ssg 使用 dip 来进行 snat  

  命令：get dip all 可查看所有已定义的dip

![img](/Users/fangcong/source/study-log/md/../images/ssgSNAT.png)

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

