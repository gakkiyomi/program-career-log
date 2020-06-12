# NSX-T集成

##### 基础概念

* section(区域) :  类似于硬件防火墙的zone，zone绑定的元素的匹配优先级要高于策略，即策略的应用对象会被它覆盖掉。区别是，section属于逻辑上的划分，而zone是和接口绑定的

* rule(规则)：sdn环境下的防火墙规则. 由于sdn环境下，数据包会经过虚拟的软件交换机，路由器等，内容会被重新封装，所以五元组会有些变化

  * 源和目的

    * 单个或者多个ip地址
    * IPSet对象(相当于地址组) ip-sets
    * 逻辑交换机 logic-switch
    * 逻辑端口 logic-port
    * NS组 ns-group
      * 逻辑交换机
      * 逻辑端口
      * IPSet
      * MACSet
      * NS组

  * 服务 application/service

    仍然由协议／源端口／目的端口组成

    * 使用NSX-T内置的对象(NSService)
    * 自定义

  * 应用对象

    * 逻辑交换机
    * 逻辑端口
    * NS组

  * 日志，可以选择开启或者关闭

  * 动作

    * 允许/丢弃/拒绝

  * 高级选项

    * 方向: 入站／出站 (类似于cisco in表out表，策略只应用到指定方向的流量上)

##### 官方API接口

https://code.vmware.com/apis/547/nsx-t



##### 用户和角色

- POST /api/v1/aaa/registration-token    创建注册访问token
- DELETE /api/v1/aaa/registration-token/<token>   删除token
- GET /api/v1/aaa/registration-token/<token>     获取token
- GET /api/v1/aaa/role-bindings      Get all users and groups with their roles
- POST /api/v1/aaa/role-bindings    将角色分配给用户或组
- POST /api/v1/aaa/role-bindings?action=delete_stale_bindings
- DELETE /api/v1/aaa/role-bindings/<binding-id>
- GET /api/v1/aaa/role-bindings/<binding-id>
- PUT /api/v1/aaa/role-bindings/<binding-id>
- GET /api/v1/aaa/roles
- GET /api/v1/aaa/roles/<role>
- GET /api/v1/aaa/user-info
- GET /api/v1/aaa/vidm/groups
- POST /api/v1/aaa/vidm/search
- GET /api/v1/aaa/vidm/users

##### IP-Sets

- GET /api/v1/ip-sets        获取所有的IPSet
- POST /api/v1/ip-sets      新增一个IPSet
- DELETE /api/v1/ip-sets/<ip-set-id>  根据id删除一个IPSet
- GET /api/v1/ip-sets/<ip-set-id>   根据id获取一个IPSet
- POST /api/v1/ip-sets/<ip-set-id>  根据id add一个ip地址或者remove一个ip地址
  - ![1556605031521](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1556605031521.png)
- PUT /api/v1/ip-sets/<ip-set-id>   根据id修改IPSet 可修改的参数包括说明，显示名称，ip地址
- GET /api/v1/ip-sets/<ip-set-id>/members  根据id获取所有的ip地址

##### LogicalPorts

- GET /api/v1/logical-ports  	    获取所有的逻辑端口
- POST /api/v1/logical-ports        增加一个逻辑端口
- DELETE /api/v1/logical-ports/<lport-id>  根据id删除一个逻辑端口
- GET /api/v1/logical-ports/<lport-id>        根据id获取一个逻辑端口
- PUT /api/v1/logical-ports/<lport-id>        更新一个逻辑端口
  - ![1556605983789](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1556605983789.png)
- GET /api/v1/logical-ports/<lport-id>/mac-table     获取逻辑端口的mac地址表（没有通过测试）
- GET /api/v1/logical-ports/<lport-id>/mac-table?format=csv       （没有通过测试）
- GET /api/v1/logical-ports/<lport-id>/state                      获取逻辑端口的真实状态
- GET /api/v1/logical-ports/<lport-id>/statistics                获取给定id的逻辑端口的统计信息
- GET /api/v1/logical-ports/<lport-id>/status                    获取给定id的逻辑端口的操作状态
- GET /api/v1/logical-ports/status                                             获取所有逻辑端口的的操作状态

##### 逻辑交换机

- GET /api/v1/logical-switches                    获取所有的逻辑交换机
- POST /api/v1/logical-switches                 增加一个逻辑交换机   必须指定以下字段
  - ![1556607913026](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1556607913026.png)
- DELETE /api/v1/logical-switches/<lswitch-id>                 根据id删除一个逻辑交换机
- GET /api/v1/logical-switches/<lswitch-id>                       根据id获取一个逻辑交换机
- PUT /api/v1/logical-switches/<lswitch-id>                       根据id修改一个逻辑交换机
  - ![1556610295261](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1556610295261.png)
- GET /api/v1/logical-switches/<lswitch-id>/mac-table      （暂未测试通过）
- GET /api/v1/logical-switches/<lswitch-id>/mac-table?format=csv
- GET /api/v1/logical-switches/<lswitch-id>/state              获取逻辑交换机的真实状态           
- GET /api/v1/logical-switches/<lswitch-id>/statistics        获取给定id的逻辑交换机的统计信息
- GET /api/v1/logical-switches/<lswitch-id>/summary      获取给定逻辑交换机的运行时状态信息
- GET /api/v1/logical-switches/<lswitch-id>/vtep-table     (暂未测试通过)
- GET /api/v1/logical-switches/<lswitch-id>/vtep-table?format=csv      (暂未测试通过)
- GET /api/v1/logical-switches/state         获取给定id的逻辑交换机的真实状态
- GET /api/v1/logical-switches/status        获取所有逻辑交换机的的状态摘要

##### NSService

- GET /api/v1/ns-services     获取所有的服务
- POST /api/v1/ns-services   新建一个服务
  - ![1556612393036](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1556612393036.png)
- DELETE /api/v1/ns-services/<ns-service-id>       根据id删除一个服务
- GET /api/v1/ns-services/<ns-service-id>             根据id获取一个服务
- PUT /api/v1/ns-services/<ns-service-id>             根据id修改一个服务
  - ![1556613010047](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1556613010047.png)

##### NSGroups

- GET /api/v1/ns-groups           获取所有的NSGroups
- POST /api/v1/ns-groups        增加一个NSGroups
  - ![1556613843369](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1556613843369.png)
- DELETE /api/v1/ns-groups/<ns-group-id>        根据id删除一个NSGroups
- GET /api/v1/ns-groups/<ns-group-id>              根据id获得一个NSGroups
- POST /api/v1/ns-groups/<ns-group-id>           增加或移除一个NSGroups
- PUT /api/v1/ns-groups/<ns-group-id>              修改NSGroups
- GET /api/v1/ns-groups/<ns-group-id>/effective-ip-address-members    得到有效的ip地址
- GET /api/v1/ns-groups/<ns-group-id>/effective-logical-port-members  得到有效的逻辑端口
- GET /api/v1/ns-groups/<ns-group-id>/effective-logical-switch-members 得到有效的逻辑交换机
- GET /api/v1/ns-groups/<ns-group-id>/effective-virtual-machine-members 得到有效的虚拟机
- GET /api/v1/ns-groups/<ns-group-id>/member-types   得到类型 有三种 
  - IPSet
  - LogicalPort
  - LogicalSwitch
- GET /api/v1/ns-groups/<nsgroup-id>/service-associations
- GET /api/v1/ns-groups/unassociated-virtual-machines

##### Ns Service Groups

- GET /api/v1/ns-service-groups     获取所有的Ns Service Groups
- POST /api/v1/ns-service-groups
- DELETE /api/v1/ns-service-groups/<ns-service-group-id>
- GET /api/v1/ns-service-groups/<ns-service-group-id>
- PUT /api/v1/ns-service-groups/<ns-service-group-id>

##### Mac Sets

- GET /api/v1/mac-sets          获取所有的mac地址
- POST /api/v1/mac-sets        新增mac地址 参数如下：
  - ![1557019656724](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1557019656724.png)
- DELETE /api/v1/mac-sets/<mac-set-id>    根据id删除
- GET /api/v1/mac-sets/<mac-set-id>          根据id获得
- PUT /api/v1/mac-sets/<mac-set-id>         根据id修改
- GET /api/v1/mac-sets/<mac-set-id>/members    根据id获得一个mac-set对象中的所有mac地址
  - ![1557019924667](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1557019924667.png)
- POST /api/v1/mac-sets/<mac-set-id>/members    根据id在一个mac-set对象中增加mac地址 参数如下
  - ![1557020034450](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1557020034450.png)
- DELETE /api/v1/mac-sets/<mac-set-id>/members/<mac-address>       删除一个mac-set对象中的一个mac地址

Logical Router

- GET /api/v1/logical-routers     获取所有的逻辑路由器
- POST /api/v1/logical-routers   新增一个逻辑路由器
  - ![1557025347913](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1557025347913.png)
- DELETE /api/v1/logical-routers/<logical-router-id>  根据id删除一个逻辑路由器
- GET /api/v1/logical-routers/<logical-router-id>   根据id获得
- POST /api/v1/logical-routers/<logical-router-id>?action=reprocess   更新路由器配置
- POST /api/v1/logical-routers/<logical-router-id>?action=reallocate   重新分配第一层服务路由器的边缘节点位置
  - ![1557025796503](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1557025796503.png)
- PUT /api/v1/logical-routers/<logical-router-id>  根据id更新 参数如下
  - ![1557026008342](C:\Users\wuqihuan\AppData\Roaming\Typora\typora-user-images\1557026008342.png)
- GET /api/v1/logical-routers/<logical-router-id>/routing/bgp/neighbors/status   
- GET /api/v1/logical-routers/<logical-router-id>/routing/forwarding-table?format=csv
- GET /api/v1/logical-routers/<logical-router-id>/routing/forwarding-table
- GET /api/v1/logical-routers/<logical-router-id>/routing/route-table?format=csv
- GET /api/v1/logical-routers/<logical-router-id>/routing/route-table
- GET /api/v1/logical-routers/<logical-router-id>/routing/routing-table?format=csv
- GET /api/v1/logical-routers/<logical-router-id>/routing/routing-table
- GET /api/v1/logical-routers/<logical-router-id>/status

##### Nat

- GET /api/v1/logical-routers/<logical-router-id>/nat/rules   获取所有的NAT规则
- POST /api/v1/logical-routers/<logical-router-id>/nat/rules  增加一个NAT规则
- DELETE /api/v1/logical-routers/<logical-router-id>/nat/rules/<rule-id>   根据id删除一个NAT规则
- GET /api/v1/logical-routers/<logical-router-id>/nat/rules/<rule-id>   根据id精确查询一个NAT规则
- PUT /api/v1/logical-routers/<logical-router-id>/nat/rules/<rule-id>   根据id修改一个NAT规则
- GET /api/v1/logical-routers/<logical-router-id>/nat/rules/<rule-id>/statistics  获取逻辑路由器NAT规则的统计信息
- GET /api/v1/logical-routers/<logical-router-id>/nat/rules/statistics  获取所有的逻辑路由器NAT规则的统计信息
- GET /api/v1/transport-nodes/<node-id>/statistics/nat-rules   获取传输节点上所有逻辑路由器NAT规则的统计信息