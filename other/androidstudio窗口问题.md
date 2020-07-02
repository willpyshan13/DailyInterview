在最新的androidstudio 4.0中，原先是有双屏幕的情况下， 把扩展的显示器拔掉之后，as就无法显示了，只有显示一个白白的东西，然后窗口不知道显示去哪里，不论是重启电脑还是重启as都无法正常打开。

这时候需要去删除一个东西 C:\Users\will\.AndroidStudio4.0\config\options\recentProjects.xml  将这个文件删除即可正常打开as
