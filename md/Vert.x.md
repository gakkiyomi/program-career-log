# Vert.x

### 简介

>Vertx，是一个基于JVM、轻量级、高性能的应用平台，非常适用于移动端后台、互联网、企业应用架构。
>
>Vertx，基于Netty全异步通信，并扩展出了很多有用的特性。
>
>Vertx，是基于事件总线设计的高性能架构，保证应用中不同部分以一种非堵塞的线程安全方式通讯。
>
>Vertx，是借鉴Erlang和Akka架构设计，能充分利用多核处理器性能并实现高并发编程需求的框架。

**Vertx特点**：

- **支持多种编程语言**

  目前支持Java、JavaScript、Ruby、Python、Groovy、Clojure、Ceylon等，并提供友好的API接口。以上技术栈的工程师可以非常容易的学习和使用Vert.x 架构。

- **异步无锁编程**

  经典的多线程编程模型能满足很多Web开发场景，但随着移动互联网并发连接数的猛增，多线程并发控制模型性能难以扩展，同时要想控制好并发锁需要较高的技巧，目前Reactor异步编程模型开始跑马圈地，而Vert.x就是这种异步无锁编程的一个首选。

  （注：Reactor？文末有解释）

- **对各种IO的丰富支持**

  目前Vert.x的异步模型已支持TCP、UDP、FileSystem、DNS、EventBus、Sockjs等，基本满足绝大多数系统架构需求。

- **分布式消息传输**

  Vert.x基于分布式Bus消息机制实现其Actor模型，我们的业务逻辑如果依赖其他Actor则通过Bus简单的将消息发送出去就可以了。EventBus事件总线，可以轻松编写分布式解耦的程序，具有很好的扩展性。

  EventBus也是Vert.x架构的灵魂所在。

- **生态体系日趋成熟**

  Vertx归入Eclipse基金会门下，异步驱动已经支持了Postgres、MySQL、MongoDB、Redis等常用组件，并且有若干Vertx在生产环境中的应用案例。

- **Vertx是轻量级的**

  vertx的核心代码包只有650kB左右，同时提供丰富的扩展插件，满足各类需求。

- **Vertx并不是一个Web容器**

  Vertx并不是一个Web Server，它是一种异步编程框架，你可以将自己基于vert.x的应用程序放置到任何你想放置的Web容器中部署运行，可以非常方便的和Spring，Spring Boot，Spring Cloud，Nodejs等语言混编。

- **模块化**

  Vertx本身内置强大的模块管理机制,当你写完一个Vert.x业务逻辑的时候,你可以将其打包成module,然后部署到基于Maven的仓库里,与现有主流的开发过程无缝结合。

- **支持WebSocket**

  支持WebSocket协议兼容SockJS ， 可以非常方便的实现web前端和服务后端长连接通信，是轻量级web聊天室应用首选解决方案。

- **使用简单**

  这里的简单意味着你编写的代码是完全基于异步事件的,类似Node.JS,与此同时.你不需要关注线程上的同步,与锁之类的概念,所有的程序都是异步执行并且通信是无阻塞的。

- **良好的扩展性**

  因为基于Actor模型,所以你的程序都是一个点一个点的单独在跑,一群点可以组成一个服务,某个点都是可以水平扩展,动态替换,这样你的程序,基本就可以达到无限制的水平扩展。

- **高并发性**

  vert.x是一个事件驱动非阻塞的异步编程框架，你可以在极少的核心线程里占用最小限度的硬件资源处理大量的高并发请求。

  此并发并非JDK库的并发,当你Coding的时候,不再关注其锁,同步块,死锁之类的概念,你就可以随性所欲的写自己的业务逻辑,Vert.x本身内置三种线程池帮你处理。

___

### Vert.x Core

**Vert.x 的核心 Java API 被我们称为 Vert.x Core**。

Vert.x Core 提供了下列功能:

- 编写 TCP 客户端和服务端
- 编写支持 WebSocket 的 HTTP 客户端和服务端
- 事件总线
- 共享数据 —— 本地的Map和分布式集群Map
- 周期性、延迟性动作
- 部署和撤销 Verticle 实例
- 数据报套接字
- DNS客户端
- 文件系统访问
- 高可用性
- 集群



### Example 

This is  [get start](http://vertxchina.github.io/vertx-translation-chinese/core/Core.html "get start"). 

