
# Java函数式编程
---
# 和面向对象区别
面向对象由大局分析领域模型，再到细节,注重设计模式,讲求抽象，将变和不变进行分离，自顶而下的感觉

函数式由细节组合成大局,函数相互组合，函数+函数=新的函数，高阶函数,纯函数,偏函数,自下向上的感觉,关注结果，在处理数据方面有优势

---
# Lambda
---
# Lambda--介绍
λ演算的函数可以接受函数当作输入（引数）和输出（传出值）,高阶函数
语法糖，简化代码,没有lambda之前使用匿名类实现回调，`this`不同,

---
# Lambda--类型推断

    !java
    String[] strArr = {"Hello","World"};
    HashMap<String,Integer> map = new HashMap<>();

---
# Lambda--java8 函数接口

- Predicate<T>: 判断接口，参数T，返回boolean
- BinaryOperator<T>: 二元操作符， 传入的两个参数的类型和返回类型相同， 继承BiFunction
- UnaryOperator<T>: 一元操作符， 继承Function,传入参数的类型和返回类型相同
- Consumer<T>: 传入一个参数，无返回值，纯消费
- Function<T>: 传入一个参数，返回一个结果
- Supplier<T>: 无参数传入，返回一个结果

---
# Lambda--java8 之前函数接口
- java.lang.Runnable
- java.util.concurrent.Callable
- java.util.Comparator
- java.io.FileFilter
- java.security.PrivilegedAction
- java.nio.file.PathMatcher
- java.lang.reflect.InvocationHandler
- java.beans.PropertyChangeListener
- java.awt.event.ActionListener
- javax.swing.event.ChangeListener

---
# Lambda--Predicate 
判断接口，参数T，返回boolean

代码实现：

    !java
    @FunctionalInterface
    public interface Predicate<T> {
        boolean test(T t);
    }

使用：

    !java
    Predicate<Integer> lessThanZero = x->x<0;
    System.out.printf("5 is Less Than Zero?" + lessThanZero.test(5));

---
# Lambda--BinaryOperator 
二元操作符， 传入的两个参数的类型和返回类型相同

代码实现：

    !java
    @FunctionalInterface
    public interface BinaryOperator<T> extends BiFunction<T,T,T> {
        public static <T> BinaryOperator<T> minBy(Comparator<? super T> comparator) {
            Objects.requireNonNull(comparator);
            return (a, b) -> comparator.compare(a, b) <= 0 ? a : b;
        }
        public static <T> BinaryOperator<T> maxBy(Comparator<? super T> comparator) {
            Objects.requireNonNull(comparator);
            return (a, b) -> comparator.compare(a, b) >= 0 ? a : b;
        }
    }
    @FunctionalInterface
    public interface BiFunction<T, U, R> {
        R apply(T t, U u);
        default <V> BiFunction<T, U, V> andThen(Function<? super R, ? extends V> after) {
            Objects.requireNonNull(after);
            return (T t, U u) -> after.apply(apply(t, u));
        }
    }

---
# Lambda--BinaryOperator 
代码示例

    !java
    BinaryOperator<Integer> area = (x, y)-> x*y;
    System.out.println("width:"+5+",height:"+10+",area:"+area.apply(5,10));
---
# Lambda--Consumer 
传入一个参数，无返回值，纯消费

代码实现：

    !java
    @FunctionalInterface
    public interface Consumer<T> {
        void accept(T t);
        default Consumer<T> andThen(Consumer<? super T> after) {
            Objects.requireNonNull(after);
            return (T t) -> { accept(t); after.accept(t); };
        }
    }
代码示例：

    !java
    Consumer<String> sayHi = x-> System.out.println("Hi,"+x);
    sayHi.accept("祝大师");
---
# Lambda--Function 
传入一个参数，返回一个结果

代码实现：

    !java
    @FunctionalInterface
    public interface Function<T, R> {
        R apply(T t);
        default <V> Function<V, R> compose(Function<? super V, ? extends T> before) {
            Objects.requireNonNull(before);
            return (V v) -> apply(before.apply(v));
        }
        default <V> Function<T, V> andThen(Function<? super R, ? extends V> after) {
            Objects.requireNonNull(after);
            return (T t) -> after.apply(apply(t));
        }
        static <T> Function<T, T> identity() {
            return t -> t;
        }
    }
代码示例：

    !java
    Function<String,Integer> parseInt = x -> Integer.parseInt(x);
    System.out.println(parseInt.apply("12"));

---
# Lambda--Supplier 
无参数传入，返回一个结果

代码实现：

    !java
    @FunctionalInterface
    public interface Supplier<T> {
        T get();
    }

代码示例:

    !java
    Supplier<Double> getPi = ()->Math.PI;
    System.out.println(getPi.get());


---
# Lambda--其他示例

    !java
    Runnable helloWorld = () -> System.out.println("hello world");
    new Thread(helloWorld).start();

    Integer[] scores = {90,76,23,45,41};
    Arrays.sort(scores, (x, y)-> x-y);
    Arrays.stream(scores).forEach((x)-> System.out.println(x));

---
# Lambda--自定义函数接口

    !java
    @FunctionalInterface
    public interface Worker {
        public void doWork();
    }

    public static class Executor{
        private void execute(Worker worker){
            worker.doWork();
        }
    }
    //调用
    Executor executor = new Executor();
    executor.execute(()-> System.out.println("export data"));

问题：能否去掉注解FunctionalInterface？

.notes: 函数接口只允许一个抽象方法，不加注解定义第二个抽象方法编译通过，但是lambda无法运行，加了注解，在编译时就无法通过，提前发现问题，加函数注解从语义方面也更好理解 

---
# Stream
---
# Stream 常用方法
- of(...) 已参数创建一个stream
- map(Function) 转换成另外一个值，得到新的集合
- filter(Predicate) 过滤掉集合中的元素，得到新的集合
- collect(toList()) ：将stream转换成一个list
- flatMap(Function): 将多个stream合并成一个stream返回
- min(Comparator): 获取最小值
- max(Comparator): 获取最大值
- reduce(BinaryOperator)
- sorted()
- limit()
- distinct()
- forEach()
- peek() 获取流的值，又不影响流的后续操作

---
# Stream 代码示例：

    !java
    User user1 = new User(1);
    User user2 = new User(2);
    User user3 = new User(3);
    List<User> users = Stream
        .of(user1,user2,user3)  //创建Stream
        .map(user->{
            user.setUsername(user.username.toUpperCase());
            return user;
            })  //将User集合映射为用户名的集合
        .filter(user->user.getId()>1)
        .collect(Collectors.toList());
    users.stream().forEach(user-> System.out.println(user.getUsername()));

    Stream<User> userStream = Stream.of(asList(user1),asList(user2,user3))
        .flatMap(userlist->userlist.stream());
    Integer maxId = userStream.max(Comparator.comparing(user -> user.getId()))
            .get().getId();

    Stream.of(1,2,3).reduce((x,y)->x+y).get();

---
# Stream 数字处理
处理数据，常用的方法sum,min,max,count,average
- IntStream
- DoubleStream
- LongStream

代码示例

    !java
    IntSummaryStatistics stat = IntStream.range(1,100).summaryStatistics();
    System.out.println("[1,..,100] average:"+stat.getAverage());
    System.out.println("[1,..,100] max:"+stat.getMax());
    System.out.println("[1,..,100] min:"+stat.getMin());
    System.out.println("[1,..,100] count:"+stat.getCount());
    System.out.println("[1,..,100] sum:"+stat.getSum());
---

# Stream Collectors 收集器 

从流转换到数据

- toList,toSet,toCollection,... 转换到集合
- maxBy,minBy,averagingInt,... 转换成值
- partitioningBy,groupingBy 数据分组
- joining 字符串拼接
- mapping,groupingBy,partitioningBy,... 可以传入下游收集器，组合多个收集器

代码示例：

    !java
        List intList = Stream.of(2,1,2,3,4,9,5).collect(Collectors.toList());
        Set intSet =Stream.of(2,1,2,3,4,9,5).collect(Collectors.toSet());
        Set intTreeSet =Stream.of(2,1,2,3,4,9,5)
                .collect(Collectors.toCollection(TreeSet::new));
        Optional<User> maxIdUser = users.stream()
                .collect(Collectors.maxBy(Comparator.comparing(User::getId)));
        Map<Boolean,List<Integer>> numbers =Stream.of(2,1,2,3,4,9,5)
                .collect(Collectors.partitioningBy(x->x%2==0));
        Map<Boolean,Long> numbersAvgMap =Stream.of(2,1,2,3,4,9,5)
                .collect(Collectors.partitioningBy(x->x%2==0,Collectors.counting()));

---

# Stream 自定义收集器
自定义收集器需要实现Collector接口，接口三个泛型定义，第一个为Stream中的数据类型，第二个为中间结果的保存类型，第三个为收集器最终返回的类型

接口方法:

- supplier() 工厂方法，初始化中间结果的保存类型
- accumulator() 累加器，需要返回实现函数，传入为中间保存结果的类型和stream中的一个数据
- combiner() 合并，在并行计算完，调用合并，传入2个中间保存结果类型
- finisher() 合并完处理，最终将中间保存结果类型转换成最终结果
- Characteristics() 特性设置

---
# Stream 自定义收集器

代码示例：

    !java
    class JoiningColletor implements Collector<String,StringJoiner,String>{
        @Override
        public Supplier<StringJoiner> supplier() {
            return ()-> new StringJoiner(",","[","]");
        }
        @Override
        public BiConsumer<StringJoiner,String> accumulator() {
            return (joiner,str)->joiner.add(str);
        }
        @Override
        public BinaryOperator<StringJoiner> combiner() {
            return (joiner1,joiner2)->joiner1.merge(joiner2);
        }
        @Override
        public Function<StringJoiner,String> finisher() {
            return joiner->joiner.toString();
        }
        @Override
        public Set<Characteristics> characteristics() {
            return new HashSet<>();
        }
    }
    String result = Stream.of("Hello","World").collect(new JoiningColletor());


---
# Stream 惰性求值

Stream创建的时候不会计算，只有产生值的时候才会计算，判断是否求值：看返回结果，如果返回的是stream则没有求值，返回其他的值才会计算
类似于建造者模式

代码示例：

    !java
    Stream newUsersStream = users.stream()
            .filter(user -> user.getId()>95)
            .map(user -> {
                System.out.println("new user id:"+user.getId());
                return user;
            });
    System.out.println("Not begin calc");
    Long count = newUsersStream.count();
    System.out.println("calc end "+count);

---
# Stream 并行

简单，无须自己控制线程和进程，省去自己判断cpu核数等操作。

数据处理结果必须与数据的处理顺序无关;不要在处理时，加同步操作;

不一定比串行性能高，根据数据量,单条数据计算时长,机器的核数等来决定是否使用。

- parallelStream
- Arrays.parallelPrefix() 给定函数，输入为前N个数据，返回为函数计算结果
- Arrays.parallelSetAll() 并行设置数组的值
- Arrays.parallelSort() 并行对数组排序
---

# 方法引用

- 静态方法引用：ClassName::methodName
- 实例上的实例方法引用：instanceReference::methodName
- 超类上的实例方法引用：super::methodName
- 类型上的实例方法引用：ClassName::methodName
- 构造方法引用：Class::new
- 数组构造方法引用：TypeName[]::new

---
# 方法引用

代码示例：

    !java
    //静态方法引用
    Function<String,Optional> nullable = Optional::ofNullable;
    Optional<String> nullableOptional = nullable.apply("static method reference");
    nullable = x->Optional.ofNullable(x);
    nullableOptional = nullable.apply("static method reference");

    //实例方法引用
    User user = new User(1);
    Function<User,String> getUsername =  User::getUsername;
    getUsername =  u -> u.getUsername();

    //构造方法引用
    Function<Integer,User> newUser = User::new;
    User user2 = newUser.apply(2);
    newUser = x -> new User(x);
    user2 = newUser.apply(2);

---
# 其他
---
# 其他--接口的default方法
java8之前，接口里不允许有实现，而接口的实现类，必须实现接口里定义的所有方法。

问题：那么如果一个接口有100个实现类，此时往接口里添加一个方法声明，会有什么问题？

.notes: 必须在每个实现类里加上方法的实现

--- 
# 其他-- 接口的default方法

default方法允许我们在接口里实现一个虚方法，若实现类里有该方法的实现，则调用实现类里的方法，如果没有，则调用接口里的默认实现。此时拓展接口的时候，若方法通用，就无需修改实现类

default方法覆盖规则：

实现类>子接口>父接口

问题： 实现类继承自2个接口，这2个接口有相同的方法，是否可以？

.notes: 实现类若不重写该方法，编译不通过

---
# 其他-- 接口的静态方法

工具类可以直接方法接口里

Stream.of 实现代码：
    
    !java
    @SafeVarargs
    @SuppressWarnings("varargs") // Creating a stream from an array is safe
    public static<T> Stream<T> of(T... values) {
        return Arrays.stream(values);
    }

---

# 其他-- 接口和抽象类的区别

- 接口允许多重继承，没有成员变量
- 抽象类拥有成员变量，却不能多重继承

---
# 其他-- Optional

Optional相当于对象的容器,可以用来取代null

    !java
    Optional<String> optional =  Optional.of("Hello Optional");
    System.out.println(optional.get());
    Optional empty = Optional.empty();
    System.out.println(empty.orElse("没有值就是我"));
    Optional alsoEmpty = Optional.ofNullable(null);
    System.out.println(alsoEmpty.orElse("没有值就是我"));
    Optional normal = Optional.ofNullable("我有值");
    System.out.println(normal.orElse("没有值就是我"));
    Optional<String> exception =  Optional.of(null); //抛异常



