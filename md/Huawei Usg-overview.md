# Huawei Usg防火墙概览

>输入 ‘?’ 号 可以命令提示，tab补全命令，quit或者ctrl + z 可以退回上个层级

##### user guide

http://ftp.sky-cloud.com:8000/f/14624ebd55924db9b290/?dl=1

##### 进入配置configure模式

```
system-view
```

##### 提交配置,用来保存当前配置信息到系统的存储路径中

```
save all
```

##### 获取running配置

```
display current-configuration all
```

##### hostname

```
sysname USG6000V2
```

##### interface

```
display interface
```

```
interface GigabitEthernet0/0/0
 undo shutdown
 ip binding vpn-instance default
 ip address 192.168.1.60 255.255.255.0
 service-manage http permit
 service-manage https permit
 service-manage ping permit
 service-manage ssh permit
 service-manage snmp permit
 service-manage telnet permit
 service-manage netconf permit
```

##### Logging

```
display logbuffer
```

##### address (group)

```
display ip address-set all
```

```
ip address-set hello type object
 address 0 11.10.1.0 mask 25
```

```
ip address-set ttttt type group
  description asdasd
  address range 10.10.12.2 10.10.12.10
  address address-set addr
  address address-set kkk
  address address-set uuu
  address range 10.10.123.2 10.10.123.10
```
##### service (group)

```
display ip service-set all
```

```
ip service-set fdf type object
    description tgasfasd
    service protocol tcp source-port 0 to 2 destination-port 0 to 65
    service protocol udp source-port 0 to 655 destination-port 0 to 65535
    service protocol tcp source-port 0 to 76 destination-port 88 to 999
    service protocol tcp source-port 666 destination-port 777 to 4564
    service protocol icmp icmp-type 8 9
    service protocol 111
    service protocol icmp icmp-type host-unreachable
```

```
ip service-set zxvasfasfsafa type group
    description asdasdsd
    service service-set ad
    service service-set ah
    service service-set bgp
    service service-set discard-tcp
```

##### zone

```
display zone
```

```
firewall zone trust
 set priority 85
 add interface GigabitEthernet0/0/0
```

```
firewall zone name aaa
 set priority 20
```

##### application

```
display application user-defined
```

```
sa
  user-defined-application name UD_3333
    description ada
    data-model browser-based
    label Productivity-LossEvasiveTunnelingSupports-VideoSocial-ApplicationsNetwork-StorageDatabase
    rule name zxc
    protocol tcp
    ip-address 2.2.2.2
    port 3333
    signature context packet direction both plain-string vva field General-Payload
    rule name aaz
    port 6600
    signature context packet direction request regular-expression "aaa?" field General-Payload
    rule name azxc
    ip-address 2.2.2.2
    port 55
    port 66
    port 44
    undo signature
```

##### policy

```
display security-policy all
```

```
security-policy
  rule name dfsd
    description fdsdfd
    source-zone trust
    source-zone local
    destination-zone aaa
    destination-zone untrust
    source-address address-set addr
    source-address address-set asdf
    destination-address address-set addr
    destination-address address-set fangcong
    service ad
    service ah
    application app HTML2JPG_Enterprise_Version
    application category Business_Systems sub-category Auth_Service
    application app-group dvsd
    time-range time1
    profile av zxcss
    profile ips web_server
    action permit
    policy logging
    session logging
    session aging-time 324
    long-link enable
    long-link aging-time 3243
```
##### timeRange

```
display time-range all
```

```
time-range abc
  period-range 01:30:00 to 23:00:00 Wed Tue Mon   
  absolute-range 00:00:00 2019/10/9 to 00:00:00 2019/10/10 
  absolute-range 00:00:00 2019/10/15 to 00:00:00 2019/10/24
```
##### interface


```
display interface
```

```
interface GigabitEthernet0/0/0
 undo shutdown
 ip binding vpn-instance default
 ip address 192.168.1.60 255.255.255.0
 service-manage http permit
 service-manage https permit
 service-manage ping permit
 service-manage ssh permit
 service-manage snmp permit
 service-manage telnet permit
 service-manage netconf permit
```

##### Errors

```
 Error:Unrecognized command found at '^' position.
```

```
 Error:Incomplete command found at '^' position.
```