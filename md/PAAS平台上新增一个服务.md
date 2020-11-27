# PAAS平台上新增一个服务

nap即将迁到paas上面，这里介绍下一个服务加入到paas平台所需要进行的工作。

**步骤：**

1. 在**kong**上注册服务
2. 在**kong**添加服务路由
3. 在keycloak上面创建sky-nap的角色
4. 将nap的api分为多个模块，在keycloak上创建角色
5. 在cmdb中注册应用和api路径
6. 在nap中集成auth



