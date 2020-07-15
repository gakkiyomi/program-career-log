# 工作相关

### 启动事件系统

~~~shell
go run main.go --logfile /var/log/eventti/eventti.log --loglevel INFO --listen-jrpc 0.0.0.0:8182 --listen-api 0.0.0.0:8184 --db_username eventti --db_password r00tme --db_name eventti --db_addr 192.168.1.222:5432 --es_addr 192.168.1.146:9200 --grpc_addr 0.0.0.0:8188
~~~

### windows 查看端口占用和服务占用

根据端口查询pid

~~~powershell
netstat  -ano | findstr "8185"
~~~

根据pid查询服务

~~~powershell
tasklist  | findstr   "16436"
~~~

