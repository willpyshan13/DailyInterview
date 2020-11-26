1、android控制 io口

https://developer.android.com/things/sdk/pio/gpio

2、pwm


https://developer.android.com/things/sdk/pio/pwm

3、串口（uart）

https://developer.android.com/things/sdk/pio/uart

4、android gpio 控制
   修改  sys/class/gpio 查找相对应的io口来控制
   一般有两种方式，一个是用shell 去控制，一种是io流的读写
   io流可以用java 也可以用 jni方式，建议用jni的方式

   https://blog.csdn.net/zjc3909/article/details/78732374?utm_medium=distribute.pc_relevant.none-task-blog-baidulandingword-15&spm=1001.2101.3001.4242

5、android gpio  控制led灯   原理跟上面一样，将io口置为低电平或者高电平即可
