#	**LDAP概念和原理**

##### **什么是目录服务？**

1. 目录服务是一个特殊的数据库,用来保存描述性,基于属性的的详细信息,支持过滤功能。
2. 是动态的,灵活的,易扩展的。如:人员组织管理,电话簿,地址簿。 

---

##### 目录树

目录树概念：

**（一）目录树概念**

1. 目录树：在一个目录服务系统中，整个目录信息集可以表示为一个目录信息树，树中的每个节点是一个条目。

2. 条目：每个条目就是一条记录，每个条目有自己的唯一可区别的名称（DN）。

3. 对象类：与某个实体类型对应的一组属性，对象类是可以继承的，这样父类的必须属性也会被继承下来。

4. 属性：描述条目的某个方面的信息，一个属性由一个属性类型和一个或多个属性值组成，属性有必须属性和非必须属性。

---

##### 什么是LDAP?

​	LDAP（Light Directory Access Portocol），它是基于X.500标准的轻量级目录访问协议。

​    目录是一个为查询、浏览和搜索而优化的数据库，它成树状结构组织数据，类似文件目录一样。

​    目录数据库和关系数据库不同，它有优异的读性能，但写性能差，并且没有事务处理、回滚等复杂功能，不适

​    于存储修改频繁的数据。所以目录天生是用来查询的，就好象它的名字一样。

​    LDAP目录服务是由目录数据库和一套访问协议组成的系统。

---

##### 信息模型

​    在LDAP中信息以树状方式组织,在树状信息中的基本数据单元是条目,而每个条目由属性构成,属性中存储有属性类型和多个属性值。

---

##### 命名模型

​    LDAP的命名模型,也即LDAP中的条目定位方式,在LDAP中每个条目均有自己的DN,DN是条目在整个树中的唯一名称标识,如同文件系统中的路径+文件名。

---

##### 功能模型

 有四类10种操作

+ 查询类操作
  + 搜索
  + 比较
+ 更新类
  + 添加条目
  + 删除条目
  + 修改条目,修改条目名
+ 认证操作
  + 绑定
  + 解绑
+ 放弃操作
+ 扩展操作

除了扩展操作，另外9种操作是LDAP的标准操作,扩展操作是LDAP中为了增加新的功能,提供的一种标准的扩展框架,当前已经成为LDAP标准的扩展操作有修改密码，StartTLS等,不同的厂商均定义自己的扩展操作。

---

##### 安全模型

   LDAP中的安全模型主要通过身份认证,安全通道,访问控制来实现。

---

##### 关键字

| **关键字** | **英文全称**       | **含义**                                                     |
| ---------- | ------------------ | ------------------------------------------------------------ |
| **dc**     | Domain Component   | 域名的部分，其格式是将完整的域名分成几部分，如域名为example.com变成dc=example,dc=com（一条记录的所属位置） |
| **uid**    | User Id            | 用户ID cong.fang（一条记录的ID）                             |
| **ou**     | Organization Unit  | 组织单位，组织单位可以包含其他各种对象（包括其他组织单元），如“oa组”（一条记录的所属组织） |
| **cn**     | Common Name        | 公共名称，如“Thomas Johansson”（一条记录的名称）             |
| **sn**     | Surname            | 姓，如“许”                                                   |
| **dn**     | Distinguished Name | “uid=songtao.xu,ou=oa组,dc=example,dc=com”，一条记录的位置（唯一） |
| **rdn**    | Relative dn        | 相对辨别名，类似于文件系统中的相对路径，它是与目录树结构无关的部分，如“uid=tom”或“cn= Thomas Johansson” |

##### 安装openLDAP

1. 在centos 7 下安装openldap    部署地址在192.168.1.29     端口389

       yum install openldap openldap-servers openldap-clients

   2. 拷贝数据库配置文件   `DB_CONIFG`中主要是关于Berkeley DB的相关的一些配置
```
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap:ldap /var/lib/ldap/DB_CONFIG
```

3.  启动OpenLDAP Server:   slapd即standard alone ldap daemon，该进程默认监听389端口
   
   ```shell
   systemctl start slapd 
systemctl enable slapd
systemctl status slapd
   ```
   
4. 设置root用户密码

```shell
slappasswd
New password:
Re-enter new password:
{SSHA}krOGXDmiCdSXuXocOf10F96LJO5ijdXo  #记住这个,下面会用到
```

5. 新建一个rootpwd.ldif(名称是自定义的)的文件:

```shell
vim rootpwd.ldif

dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: {SSHA}krOGXDmiCdSXuXocOf10F96LJO5ijdXo
```

+ ldif即LDAP Data Interchange Format，是LDAP中数据交换的一种文件格式。文件内容采用的是key-value形式，注意value后面不能有空格。
+ 上面内容中dn即distingush name
+ olc即Online Configuration，表示写入LDAP后不需要重启即可生效
+ changetype: modify表示修改一个entry，changetype的值可以是add,delete, modify等。
+ add: olcRootPW表示对这个entry新增了一个olcRootPW的属性
+ olcRootPW: {SSHA}krOGXDmiCdSXuXocOf10F96LJO5ijdXo指定了属性值

6. 下面使用ldapadd命令将上面的rootpwd.ldif文件写入LDAP:

   ```shell
   ldapadd -Y EXTERNAL -H ldapi:/// -f rootpwd.ldif
   ```

7. 导入schema，schema包含为了支持特殊场景相关的属性，可根据选择导入，这里先全部导入:

   ```shell
   ls /etc/openldap/schema/*.ldif | while read f; do ldapadd -Y EXTERNAL -H ldapi:/// -f $f; done
   ```

8. 设定默认域 ，  先生成一个密码

   ```shell
   slappasswd
   New password:
   Re-enter new password:
   {SSHA}OpMcf0c+pEqFLZm3i+YiI2qhId1G/yM3
   ```

9. 新建一个domain.ldif的文件

     ```shell
     vim domain.ldif
     
     dn: olcDatabase={1}monitor,cn=config
     changetype: modify
     replace: olcAccess
     olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth"
       read by dn.base="cn=admin,dc=skycloud,dc=net" read by * none
     
     dn: olcDatabase={2}hdb,cn=config
     changetype: modify
     replace: olcSuffix
     olcSuffix: dc=skycloud,dc=net
     
     dn: olcDatabase={2}hdb,cn=config
     changetype: modify
     replace: olcRootDN
     olcRootDN: cn=admin,dc=skycloud,dc=net
     
     dn: olcDatabase={2}hdb,cn=config
     changetype: modify
     add: olcRootPW
     olcRootPW: {SSHA}AINL8805TMk97udEd6LXTtUHpaSKJWhP
     
     dn: olcDatabase={2}hdb,cn=config
     changetype: modify
     add: olcAccess
     olcAccess: {0}to attrs=userPassword,shadowLastChange by
       dn="cn=admin,dc=skycloud,dc=net" write by anonymous auth by self write by * none
     olcAccess: {1}to dn.base="" by * read
     olcAccess: {2}to * by dn="cn=admin,dc=skycloud,dc=net" write by * read
     ```

- `olcAccess`即access，该key用于指定目录的ACL即谁有什么权限可以存取什么
- `olcRootDN`设定管理员root用户的distingush name
- 注意替换上面文件内容中cn为具体的域信息
- `olcRootPW`用上面新生成的密码替换

10. 写入:

```shell
ldapmodify -Y EXTERNAL -H ldapi:/// -f domain.ldif
```

11. 添加基本目录

    ```shell
    dn: dc=skycloud,dc=net
    objectClass: top
    objectClass: dcObject
    objectclass: organization
    o: skycloud net
    dc: skycloud
    
    dn: cn=admin,dc=skycloud,dc=net
    objectClass: organizationalRole
    cn: admin
    description: Directory admin
    
    dn: ou=users,dc=skycloud,dc=net
    objectClass: organizationalUnit
    ou: users
    
    dn: ou=Group,dc=skycloud,dc=net
    objectClass: organizationalUnit
    ou: Group
    ```

    12. 写入:

    ```shell
    ldapadd -x -D cn=Manager,dc=zhidaoauto,dc=com -W -f basedomain.ldif
    ```

    13. 测试
    
        使用search命令查看
    
        ![test](http://gakkiyomi.com:8081/test.png)
    
        ---
    
        

##### 远程连接

​    可以下载ldapadmin 作为管理工具,进行操作

​    下载地址:  http://www.ldapadmin.org/download/ldapadmin.html

​    ![ldapadmin](http://gakkiyomi.com:8081/ldaplogin.png)

***设置密码***

![ldapadmin](http://gakkiyomi.com:8081/ldapsetpwd.png)

---

![ldap](http://gakkiyomi.com:8081/ldapadmin.png)

##### 集成Jira

​	文档： https://www.cnblogs.com/Bourbon-tian/p/8675784.html

​                https://www.cnblogs.com/imcati/p/9378668.html

##### 集成Confluence

​	文档:    https://blog.csdn.net/len9596/article/details/81258888

##### 集成Bitbucket 

​    文档:    https://www.cnblogs.com/imcati/p/10114885.html

