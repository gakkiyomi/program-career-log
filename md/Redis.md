# Redis相关问题

记录一些Redis的一些底层实现以及问题



### SDS 简单动态字符串

redis没有直接使用C语言的传统字符串表示，而是自己构建了(simple dynamic string)的抽象类型，并且广泛运用在redis的代码当中。

传统的c字符串只会在redis的代码中充当字符串字面量使用，也就是类似于打印日志时 log("xxxxx")这样使用。

sds.h/sdshdr 定义了sds的结构

~~~
struct sdshdr {
		//记录buf数组中所使用的字节数量
		//等于sds所保存的字符串的长度
		int len;
		//记录buf数组中为使用的字节数量
		int free;
		//字节数组 用于保存字符串
		char buf[];
}
~~~

![image-20210125111850155](../images/image-20210125111850155.png)

并且还沿用了c字符串的以空字符串'\0'结尾，这样可以重用一部分c字符串函数库里面的函数。

|                 C字符串                  |                  SDS                   |
| :--------------------------------------: | :------------------------------------: |
|       获取字符串长度的复杂度为O(n)       |      获取字符串长度的复杂度为O(1)      |
|    API是不安全的，可能造成缓冲区溢出     |    API是安全的，不会造成缓冲区溢出     |
| 修改字符串长度N次必然要执行N次内存重分配 | 修改字符串长度N次最多执行N次内存重分配 |
|             只能保存文本数据             |       可以保存文本或者二进制数据       |



### 对象的类型与编码

redis内置有5种对象：`字符串，列表，哈希，集合，有序集合`。而redis中也自己实现了许多的数据结构例如:`SDS，双端链表，字典，跳表，压缩列表，整数集合，哈希表`等等，这里不会讨论如何实现这些数据结构，但是redis是用这些实现的数据结构来实现它的5种内置对象的，每种对象都用到了至少一种我们刚才介绍的数据结构。

针对不同的场景，我们可以为对象设置多种不同的数据结构实现，可以优化对象在不同场景下的使用效率。

对象

|   C字符串    |                  SDS                   |
| :----------: | :------------------------------------: |
| REDIS_STRING |      获取字符串长度的复杂度为O(1)      |
|  REDIS_LIST  |    API是安全的，不会造成缓冲区溢出     |
|  REDIS_HASH  | 修改字符串长度N次最多执行N次内存重分配 |
|  REDIS_SET   |       可以保存文本或者二进制数据       |
|  REDIS_ZSET  |             有序集合的对象             |

编码

|         编码常量          |            SDS             |
| :-----------------------: | :------------------------: |
|    REDIS_ENCODING_INT     |       long类型的整数       |
|   REDIS_ENCODING_EMBSTR   | embstr编码的简单动态字符串 |
|    REDIS_ENCODING_RAW     |       简单动态字符串       |
|     REDIS_ENCODING_HT     |            字典            |
| REDIS_ENCODING_LINKEDLIST |       有序集合的对象       |
|  REDIS_ENCODING_ZIPLIST   |          压缩列表          |
|   REDIS_ENCODING_INTSET   |          整数集合          |
|  REDIS_ENCODING_SKIPLIST  |         跳表，字典         |

对象与编码的关系

|   编码常量   |            SDS            |                    对象                    |
| :----------: | :-----------------------: | :----------------------------------------: |
| REDIS_STRING |    REDIS_ENCODING_INT     |          使用整数实现的字符串对象          |
| REDIS_STRING |   REDIS_ENCODING_EMBSTR   | 使用embstr编码的动态字符串实现的字符串对象 |
| REDIS_STRING |    REDIS_ENCODING_RAW     |     使用简单动态字符串实现的字符串对象     |
|  REDIS_LIST  |  REDIS_ENCODING_ZIPLIST   |         使用压缩列表实现的列表对象         |
|  REDIS_LIST  | REDIS_ENCODING_LINKEDLIST |         使用双端列表实现的列表对象         |
|  REDIS_HASH  |  REDIS_ENCODING_ZIPLIST   |         使用压缩列表实现的哈希对象         |
|  REDIS_HASH  |     REDIS_ENCODING_HT     |           使用字典实现的哈希对象           |
|  REDIS_SET   |   REDIS_ENCODING_INTSET   |         使用整数集合实现的集合对象         |
|  REDIS_SET   |     REDIS_ENCODING_HT     |           使用字典实现的集合对象           |
|  REDIS_ZSET  |  REDIS_ENCODING_ZIPLIST   |       使用压缩列表实现的有序集合对象       |
|  REDIS_ZSET  |  REDIS_ENCODING_SKIPLIST  |      使用跳表和字典实现的有序集合对象      |