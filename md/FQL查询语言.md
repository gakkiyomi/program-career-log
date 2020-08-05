# The Fast Query Language Specification

### 介绍

**FQL(Fast Query Language)** 是天元云开发的一套快速查询语言。

支持已下数据源:

 + 使用SQL语法的关系型数据库

 + 图数据库NEO4J

 + 时序数据库Prometheus

   使用简单的K-V键值对进行检索,支持逻辑运算符和排序。

### 关键字

~~~
datasource     table      range        in           label	
selecotrs
~~~

+ **datasource**

​       指明这次查询操作指向哪种数据源

​       值可以是已下的几种

      sql 	postgres   postgressql   mysql   oracle   sqlserver   neo4j   prometheus
+ **table**

​       在关系型数据库中需要指明查询的是哪张表

​       例子: datasource = postgres and table = nap_device and name = ssg229

+ **range**

​       prometheus中的关键字，与**in**一起使用，代表查询一段时间内的数据

​       例子：datasource = prometheus and selecotrs = cmdb_node_size and range in (5m)

+ **in**

​       在关系型数据库中与关系型数据库的关键字in含义相同，指符合in后面括号里的几项

​         	例子： datasource = postgres and table = nap_device and name in (ssg229,asaNAT) 

​       在图数据库neo4j中in需要搭配方括号[]进行使用

​          key为普通基本数据类型则与关系型数据库的含义相同

​         	例子：label = skyTemplateLabel  and name in ["cmdb","echo"]

​          key为数组类型时不能带括号，代表筛选出数组存在这个值的数据

​        	  例子：label = workflow and templates in “打印信息”

+ **label**

​       图数据库neo4j中的关键字，代表要查询数据的标签label

​        例子：查询所有标签为VM的节点

​            datasource = neo4j and label = VM

+ **selectors**

​     prometheus中的关键字，代表埋点数据的度量名

​		例子： 查询cmdb节点数量

​          datasource = neo4j and selectors = cmdb_node_size



### 操作符

~~~
and         or      =       !=     	 <=     >=     <    >      ~      in     not  
order by    asc     desc   
~~~



### 排序

使用 ``order by``,``asc``,``desc``等操作符进行排序，仅支持SQL与NEO4J数据源进行排序

例子：升序        datasource = postgres and table = nap_device order by create_at asc

​			降序       datasource = postgres and table = nap_device order by create_at desc