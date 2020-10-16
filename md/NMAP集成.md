

# NMAP集成

### 方案

使用易上手，开发效率高的Python进行nmap-driver的开发，将nmap返回的数据压入消息队列，cmdb订阅此消息队列将数据存入cmdb，IPAM可以直接从cmdb中获取数据进行展示，也可以主动调用nmap-driver暴露的接口手动拉取数据展示并同步至cmdb。



### 架构图

![image.png](https://b3logfile.com/file/2020/10/image-b383f3b7.png)



### 接口设计(nmap-driver 提供给 IPAM 使用 ) RPC or HTTP?

**查看IP状态** `GET /api/nmap-driver/ip/status?ip="192.168.1.146"`

~~~json
{
    "ip":"192.168.1.146",
    "mac_addr":"00:50:56:8D:E6:97",
    "status":"UP",
    "os":"Linux 3.2 - 4.9",
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
}
~~~



**IP扫描,支持单个ip，范围range，整个网段** `GET /api/nmap-driver/scan?target="192.168.1.0/24"`

~~~json
{
    "up" :1,
    "down":253,
    "total":254,
    "result":[
        {
    	"ip":"192.168.1.146",
    	"mac_addr":"00:50:56:8D:E6:97",
    	"status":"UP",
        "os":"Linux 3.2 - 4.9",   
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
		}
    ]
}
~~~



