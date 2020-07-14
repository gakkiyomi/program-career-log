# Design pattern

>设计模式（Design pattern）代表了最佳的实践，通常被有经验的面向对象的软件开发人员所采用。设计模式是软件开发人员在软件开发过程中面临的一般问题的解决方案。这些解决方案是众多软件开发人员经过相当长的一段时间的试验和错误总结出来的。



### 单例模式

>涉及到一个单一的类，该类负责创建自己的对象，同时确保只有单个对象被创建。这个类提供了一种访问其唯一的对象的方式，可以直接访问，不需要实例化该类的对象。
>
>总所周知，单例模式分为懒汉式和饿汉式，又可根据其场景分为线程安全和线程不安全

+ 懒汉式(线程不安全)

这种方式是最基本的实现方式，这种实现最大的问题就是不支持多线程。因为没有加锁 synchronized，所以严格意义上它并不算单例模式。
这种方式 lazy loading 很明显，不要求线程安全，在多线程不能正常工作。

~~~java
public class Singleton {  
    private static Singleton instance;  
    private Singleton (){}  
  
    public static Singleton getInstance() {  
    if (instance == null) {  
        instance = new Singleton();  
    }  
    return instance;  
    }  
}
~~~

+ 懒汉式，线程安全

这种方式具备很好的 lazy loading，能够在多线程中很好的工作，但是，效率很低，99% 情况下不需要同步。

~~~java
public class Singleton {  
    private static Singleton instance;  
    private Singleton (){}  
    public static synchronized Singleton getInstance() {  
    if (instance == null) {  
        instance = new Singleton();  
    }  
    return instance;  
    }  
}
~~~

+ 饿汉式(天然线程安全)

这种方式比较常用，但容易产生垃圾对象。

~~~java
public class Singleton {  
    private static Singleton instance = new Singleton();  
    private Singleton (){}  
    public static Singleton getInstance() {  
    return instance;  
    }  
}
~~~

+ 双检锁/双重校验锁

这种方式采用双锁机制，安全且在多线程情况下能保持高性能。

~~~java
public class Singleton {  
    private volatile static Singleton singleton;  
    private Singleton (){}  
    public static Singleton getSingleton() {  
    if (singleton == null) {  
        synchronized (Singleton.class) {  
        if (singleton == null) {  
            singleton = new Singleton();  
        }  
        }  
    }  
    return singleton;  
    }  
}
~~~

+ 静态内部类

这种方式能达到双检锁方式一样的功效，但实现更简单。对静态域使用延迟初始化，应使用这种方式而不是双检锁方式。这种方式只适用于静态域的情况，双检锁方式可在实例域需要延迟初始化时使用。
这种方式同样利用了 classloader 机制来保证初始化 instance 时只有一个线程，它跟第 3 种方式不同的是：第 3 种方式只要 Singleton 类被装载了，那么 instance 就会被实例化（没有达到 lazy loading 效果），而这种方式是 Singleton 类被装载了，instance 不一定被初始化。因为 SingletonHolder 类没有被主动使用，只有通过显式调用 getInstance 方法时，才会显式装载 SingletonHolder 类，从而实例化 instance。

~~~java
public class Singleton {  
    private static class SingletonHolder {  
    private static final Singleton INSTANCE = new Singleton();  
    }  
    private Singleton (){}  
    public static final Singleton getInstance() {  
    return SingletonHolder.INSTANCE;  
    }  
}
~~~



### 工厂模式

>这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。在工厂模式中，我们在创建对象时不会对客户端暴露创建逻辑，并且是通过使用一个共同的接口来指向新创建的对象。

**意图：**定义一个创建对象的接口，让其子类自己决定实例化哪一个工厂类，工厂模式使其创建过程延迟到子类进行。

**实现:**

~~~java
public interface Shape {   //创建一个接口并定义抽象方法
   void draw();
}

public class Rectangle implements Shape {  //实现类
 
   @Override
   public void draw() {
      System.out.println("Inside Rectangle::draw() method.");
   }
}

public class Square implements Shape {    //实现类
 
   @Override
   public void draw() {
      System.out.println("Inside Square::draw() method.");
   }
}

public class ShapeFactory {   //定义一个工厂类  根据输入的类型来生成特定的对象
    
   //使用 getShape 方法获取形状类型的对象
   public Shape getShape(String shapeType){
      if(shapeType == null){
         return null;
      }        
      if(shapeType.equalsIgnoreCase("CIRCLE")){
         return new Circle();
      } else if(shapeType.equalsIgnoreCase("RECTANGLE")){
         return new Rectangle();
      } else if(shapeType.equalsIgnoreCase("SQUARE")){
         return new Square();
      }
      return null;
   }
}
~~~

**缺点：**每次增加一个产品时，都需要增加一个具体类和对象实现工厂，使得系统中类的个数成倍增加，在一定程度上增加了系统的复杂度，同时也增加了系统具体类的依赖。这并不是什么好事。

### 抽象工厂模式

>抽象工厂模式（Abstract Factory Pattern）是围绕一个超级工厂创建**其他工厂**。该超级工厂又称为其他工厂的工厂。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。
>
>在抽象工厂模式中，接口是负责创建一个相关对象的工厂，不需要显式指定它们的类。每个生成的工厂都能按照工厂模式提供对象。

**意图：**提供一个创建一系列相关或相互依赖对象的接口，而无需指定它们具体的类。

~~~java
public interface Shape {  //形状接口
   void draw();
}

public class Rectangle implements Shape {  //具体实现类
 
   @Override
   public void draw() {
      System.out.println("Inside Rectangle::draw() method.");
   }
}

public class Square implements Shape {  //具体实现类
 
   @Override
   public void draw() {
      System.out.println("Inside Square::draw() method.");
   }
}

public interface Color {  //颜色接口
   void fill();
}

public class Red implements Color {   //具体实现类
 
   @Override
   public void fill() {
      System.out.println("Inside Red::fill() method.");
   }
}

public class Green implements Color {    //具体实现类
 
   @Override
   public void fill() {
      System.out.println("Inside Green::fill() method.");
   }
}

public abstract class AbstractFactory {  //创建抽象工厂里面包含其他的工厂
   public abstract Color getColor(String color);
   public abstract Shape getShape(String shape) ;
}

public class ShapeFactory extends AbstractFactory {  //创建扩展了 AbstractFactory 的工厂类，基于给定的信息生成实体类的对象。
    
   @Override
   public Shape getShape(String shapeType){
      if(shapeType == null){
         return null;
      }        
      if(shapeType.equalsIgnoreCase("CIRCLE")){
         return new Circle();
      } else if(shapeType.equalsIgnoreCase("RECTANGLE")){
         return new Rectangle();
      } else if(shapeType.equalsIgnoreCase("SQUARE")){
         return new Square();
      }
      return null;
   }
   
   @Override
   public Color getColor(String color) {
      return null;
   }
}

public class FactoryProducer {  //创建一个工厂创造器/生成器类，通过传递形状或颜色信息来获取工厂。
   public static AbstractFactory getFactory(String choice){
      if(choice.equalsIgnoreCase("SHAPE")){
         return new ShapeFactory();
      } else if(choice.equalsIgnoreCase("COLOR")){
         return new ColorFactory();
      }
      return null;
   }
}


public class AbstractFactoryPatternDemo {
   public static void main(String[] args) {
 
      //获取形状工厂
      AbstractFactory shapeFactory = FactoryProducer.getFactory("SHAPE");
 
      //获取形状为 Circle 的对象
      Shape shape1 = shapeFactory.getShape("CIRCLE");
 
      //调用 Circle 的 draw 方法
      shape1.draw();
 
      //获取形状为 Rectangle 的对象
      Shape shape2 = shapeFactory.getShape("RECTANGLE");
 
      //调用 Rectangle 的 draw 方法
      shape2.draw();
      
      //获取形状为 Square 的对象
      Shape shape3 = shapeFactory.getShape("SQUARE");
 
      //调用 Square 的 draw 方法
      shape3.draw();
 
      //获取颜色工厂
      AbstractFactory colorFactory = FactoryProducer.getFactory("COLOR");
 
      //获取颜色为 Red 的对象
      Color color1 = colorFactory.getColor("RED");
 
      //调用 Red 的 fill 方法
      color1.fill();
 
      //获取颜色为 Green 的对象
      Color color2 = colorFactory.getColor("Green");
 
      //调用 Green 的 fill 方法
      color2.fill();
 
      //获取颜色为 Blue 的对象
      Color color3 = colorFactory.getColor("BLUE");
 
      //调用 Blue 的 fill 方法
      color3.fill();
   }
}
~~~



### 策略模式

>在策略模式（Strategy Pattern）中，一个类的行为或其算法可以在运行时更改。这种类型的设计模式属于行为型模式。
>
>在策略模式中，我们创建表示各种策略的对象和一个行为随着策略对象改变而改变的 context 对象。策略对象改变 context 对象的执行算法。

**意图: **  定义一系列的算法,把它们一个个封装起来, 并且使它们可相互替换。

**代码：**

~~~java
public interface Strategy {  //一个算法的抽象
   public int doOperation(int num1, int num2);
}

public class OperationAdd implements Strategy{ //算法的具体实现
   @Override
   public int doOperation(int num1, int num2) {
      return num1 + num2;
   }
}

public class OperationSubstract implements Strategy{ //算法的具体实现
   @Override
   public int doOperation(int num1, int num2) {
      return num1 - num2;
   }
}

public class Context {   
   private Strategy strategy; //在实用类中封装一个算法抽象
   
   public Context(){
       
   } 
   public Context(Builder builder){  //传进来的具体算法对象
      this.strategy = builder.strategy;
   }
   
   public void setStrategy(Strategy strategy){
       this.strategy = strategy;
   }
 
   public int executeStrategy(int num1, int num2){ //根据具体的算法对象，调用他们的算法实现
      return strategy.doOperation(num1, num2);
   }
    
   public static final class Builder{  //结合builder模式进行构建
       private Strategy strategy;
       
       public Builder(){
           
       }
       
       public Builder setStrategy(Strategy val){
           this.strategy = val;
           return this;
       }
       
       public Context build(){
           return new Context(this);
       }
   } 
}

public class StrategyPatternDemo { //测试
   public static void main(String[] args) {
      Context context = new Context.Builder()
          .setStrategy(new OperationAdd())
          .builder();
       System.out.println("10 + 5 = " + context.executeStrategy(10, 5));
       
       context.setStrategy(new OperationSubstract())
       System.out.println("10 - 5 = " + context.executeStrategy(10, 5));

   }
}
~~~



### 代理模式

> 在代理模式（Proxy Pattern）中，一个类代表另一个类的功能。这种类型的设计模式属于结构型模式。
>
> 在代理模式中，我们创建具有现有对象的对象，以便向外界提供功能接口。

**意图：**为其他对象提供一种代理以控制对这个对象的访问。

~~~java
public interface Image {
   void display();
}

public class RealImage implements Image {
 
   private String fileName;
 
   public RealImage(String fileName){
      this.fileName = fileName;
      loadFromDisk(fileName);
   }
 
   @Override
   public void display() {
      System.out.println("Displaying " + fileName);
   }
 
   private void loadFromDisk(String fileName){
      System.out.println("Loading " + fileName);
   }
}

public class ProxyImage implements Image{
 
   private RealImage realImage;  //在代理对象中封装一个真实对象  实例化真实对象前后可进行操作
   private String fileName;
 
   public ProxyImage(String fileName){
      this.fileName = fileName;
   }
 
   @Override
   public void display() {
      if(realImage == null){
         realImage = new RealImage(fileName);
      }
      realImage.display();
   }
}
~~~

