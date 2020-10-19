

# NMAP集成

### 方案

使用易上手，开发效率高的Python进行nmap-driver的开发，IPAM主动调用nmap-driver 的rpc接口手动同步指定ip并且纳管至cmdb。 也可以发送一个请求给nmap-driver进行ip段扫描，nmap-driver再跑完扫描任务后将返回结果压入消息队列，IPAM再监听此消息队列完成纳管。



### 架构图

![image.png](https://b3logfile.com/file/2020/10/image-6069f287.png)



### 接口设计

> (nmap-driver 提供给 IPAM 使用 ) RPC 异步 或者 消息队列

**手动同步IP** 

参数 ： ip : 192.168.1.146

~~~json
{
    "ip":"192.168.1.146",
    "status":"UP",
    "os":"Linux 3.2 - 4.9"
}
~~~



**IP扫描,支持单个ip，范围range，整个网段** 

参数  target = "192.168.1.146"    or    target = "192.168.1.0/24"     o r    target = "192.168.1.146-192.168.1.148"

~~~json
{
    "up" :1,
    "down":253,
    "total":254,
    "result":[
        {
    	"ip":"192.168.1.146",
    	"status":"UP",
        "os":"Linux 3.2 - 4.9",  
		}
    ]
}
~~~

**IPAM**从**nmap-driver** 获取到数据并且进行处理数据之后纳管至**cmdb**

模型如下

```json
{
    "ip":"192.168.1.146",
    "type":"IPv4",
    "status":"UP",  //扫描过后  如果机器关机或者宕机  再次扫描或者手动同步 都会将status置为DOWN
    "sync_status":"unsynced", //同步 | 未同步  扫描出来列表显示同步则是说明此已被cmdb纳管 反之则未同步
    "mask":"255.255.255.0",
    "subnet":"192.168.1.0/24", //根据最长前缀匹配算出网段
    "os":"Linux 3.2 - 4.9"
}
```



端口扫描（暂时不进行开发）

~~~json
"ports":[
        	{
                "port":5432,
                "type":"tcp",
                "status":"open",
                "service":{
                    "name":"postgresql",
                    "version":"PostgreSQL DB 9.6.0 or later"
                 }
        	}
   	 			]
~~~