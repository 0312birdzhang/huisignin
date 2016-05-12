#卉打卡

一款简单的签到打卡软件，比如今天要 吃饭睡觉打豆豆
软件创意来源于卉卉女神，部分图标来源于网络，版权归本人所有。
本软件开源免费，同时会支持windows、ios、android、mac os x，如果你是一个想学Qt的童鞋，可以参考一下
截图如下：


![](http://ww1.sinaimg.cn/mw690/77687413gw1f2jzk3q5twj20f00qoq4k.jpg)

![](http://ww4.sinaimg.cn/mw690/77687413gw1f2jzk5b207j20f00qot9c.jpg)

![](http://ww3.sinaimg.cn/mw690/77687413gw1f2jzk6e6wqj20f00qojsx.jpg)




##Windows版打包说明

* 使用Qt制作要打包的文件步骤
    * 首先在Qt里面选择__构建套件__为桌面的
    * 运行之后，会在build-huisignin-Desktop_Qt_5_x_x_MinGW_32bit-Release/release目录下有huisignin.exe文件
    * 复制这个文件跟源码里面的qml目录到一个临时目录，比如我放到C:\Users\BirdZhang\Desktop\tobuild
    * 在这个目录下用cmd执行<code>C:\Qt\Qt5.6.0\5.6\mingw49_32\bin\windeployqt.exe --release --qmldir=./qml huisignin.exe</code>
    * 执行完之后会产生一些文件，这时候双击huisignin.exe，会提示缺少xx.dll,到<code>C:\Qt\Qt5.6.0\5.6\mingw49_32\bin\</code>下复制过来即可
    * 直到双击运行出现界面
    
* 本软件使用[Inno Setup Compiler](http://www.jrsoftware.org/download.php/is.exe)打包，代码里面已经提供打包步骤，部分路径需要自己修改，执行编译即可打包出exe文件了


##TODO

- [ ] 提醒功能
    
    在不打扰用户休息的为前提
    
- [ ] 界面美化

- [ ] 数据统计
    
    每周每月等打卡数据统计

- [ ] 还没想到。。。
