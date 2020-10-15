

# NMAP集成

### 方案

使用易上手，开发效率高的Python进行nmap-driver的开发，将nmap返回的数据压入消息队列，cmdb订阅此消息队列将数据存入cmdb，IPAM可以直接从cmdb中获取数据进行展示，也可以主动调用nmap-driver暴露的接口手动拉取数据展示并同步至cmdb。



### 架构图

![image.png](https://b3logfile.com/file/2020/10/image-b383f3b7.png)



### 接口设计



