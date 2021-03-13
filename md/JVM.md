# JVM学习

>之前零零散散的看过一些jvm之类的知识，但都没有整理，导致每次想不起来都要去翻书或者google，这里做一次完整的记录，可被方便的索引到。

## 内存分配和回收策略

### Minor GC/Major GC /Full GC

+ Minor GC：回收新生代（包括 Eden 和 Survivor 区域），因为 Java 对象大多都具备朝生夕灭的特性，所以 Minor GC 非常频繁，一般回收速度也比较快。
+ Major GC / Full GC: 回收老年代，出现了 Major GC，经常会伴随至少一次的 Minor GC，但这并非绝对。Major GC 的速度一般会比 Minor GC 慢 10 倍 以上。
+ 在 JVM 规范中，Major GC 和 Full GC 都没有一个正式的定义，所以有人也简单地认为 Major GC 清理老年代，而 Full GC 清理整个内存堆。

### 对象优先在eden区分配

大多数情况下，对象在新生代 Eden 区中分配。当 Eden 区没有足够空间进行分配时，虚拟机将发起一次 Minor GC。

### 大对象直接进入老年代

大对象是指需要大量连续内存空间的 Java 对象，如byte[]。

一个大对象能够存入 Eden 区的概率比较小，发生分配担保的概率比较大，而分配担保需要涉及大量的复制，就会造成效率低下。

虚拟机提供了一个 `-XX:PretenureSizeThreshold `参数，令大于这个设置值的对象直接在老年代分配，这样做的目的是避免在 Eden 区及两个 Survivor 区之间发生大量的内存复制。

### 长期存活的对象进入老年代

既然jvm采用了分代收集的思想，那必然就会为对象标注当前属于那个时代，所以JVM 给每个对象定义了一个对象年龄计数器。如果对象在新生代发生一次 Minor GC 后仍然能存活，那么就会被移动到survivor区，并且对象年龄设为1，之后对象每熬过一次Minor GC，对象年龄加1，当年龄增长到一定程度后(默认15)，就会晋升到老年代中。设置阈值：-XXMaxTenuringThreshold=15

使用 -XXMaxTenuringThreshold 设置新生代的最大年龄，只要超过该参数的新生代对象都会被转移到老年代中去。

### 动态对象年龄判定

如果当前新生代的 Survivor 中，相同年龄所有对象大小的总和大于 Survivor 空间的一半，年龄 >= 该年龄的对象就可以直接进入老年代，无须等到 MaxTenuringThreshold 中要求的年龄。

### 空间分配担保

JDK 6 Update 24 之前的规则是这样的：
在发生 Minor GC 之前，虚拟机会先检查**老年代最大可用的连续空间是否大于新生代所有对象总空间**， 如果这个条件成立，Minor GC 可以确保是安全的； 如果不成立，则虚拟机会查看`HandlePromotionFailure`值是否设置为允许担保失败， 如果是，那么会继续检查老年代最大可用的连续空间是否大于历次晋升到老年代对象的平均大小， 如果大于，将尝试进行一次 Minor GC,尽管这次 Minor GC 是有风险的； 如果小于，或者 HandlePromotionFailure 设置不允许冒险，那此时也要改为进行一次 Full GC。

JDK 6 Update 24 之后的规则变为：
只要老年代的连续空间大于新生代对象总大小或者历次晋升的平均大小，就会进行 Minor GC，否则将进行 Full GC。

通过清除老年代中废弃数据来扩大老年代空闲空间，以便给新生代作担保。`HandlePromotionFailure`这个参数不会在影响空间分配担保策略了。

以上这个过程就是分配担保。

### JVM触发Full GC 的情况

1. 我们手动调用`system.gc()`方法，但这也不一定会执行Full GC，只会增加Full GC的执行频率我们可以通过`-XX:DisableExpliitGC`来禁止调用Full GC
2. 老年代空间不足，当老年代空间不足后会触发Full GC,若触发后仍然不足，则会抛出`java.lang.OutOfMemoryError:Java heap space`
3. 方法区(永久代)空间不足，方法区存放一些类信息，常量，和静态变量等数据，若系统加载的类，反射的类和调用的方法较多的时候，永久代可能被占满，则触发Full GC，若经过Full GC仍然回收不了，则会抛出 `java.lang.OutOfMemoryError:PemGen space`
4. 统计得到的Minor GC 晋升到旧生代的平均大小大于老年代的空间，则会触发Full GC
5. CMS GC 时出现 promotion failed 和 concurrent mode failure和promotion failed，就是上文所说的担保失败，而 concurrent mode failure 是在执行 CMS GC 的过程中同时有对象要放入老年代，而此时老年代空间不足造成的。



## 垃圾收集器和垃圾收集算法





## 虚拟机执行子系统

