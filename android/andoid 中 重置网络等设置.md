andoid 中 重置网络等设置

在launcher中如果需要重置网络等操作，如果直接

```
val wifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager

wifiManager.resetFactory()
```
是不行的，因为方法是隐藏的，因此有以下几个方法可以来重置网络

（以下操作均需要获取系统权限才行）

1、修改系统api，使得该方法是开放的，去除注释里面的@hide 然后重新编译android.jar 再引入即可

2、使用反射

ReflectUtils.reflect(wifiManager).method("factoryReset")

