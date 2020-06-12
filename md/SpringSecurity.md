# SpringSecurity

##### 认证流程

+ 
  + 用户使用用户名和密码进行登录。
  + `Spring Security`将获取到的用户名和密码封装成一个`Authentication`接口的实现类，比如常用的`UsernamePasswordAuthenticationToken`。
  + 将上述产生的`Authentication`对象传递给`AuthenticationManager`的实现类`ProviderManager`进行认证。
  + `ProviderManager`依次调用各个`AuthenticationProvider`进行认证，认证成功后返回一个封装了用户权限等信息的`Authentication`对象。
  + 将`AuthenticationManager`返回的`Authentication`对象赋予给当前的`SecurityContext`。

