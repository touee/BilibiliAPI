# BilibiliAPI

此package分离自其他项目, 并进行了小规模重构, 但尚未测试能否使用.

本着 "使用了这段代码的程序能正常执行就表示代码没大问题"及懒惰的原则, 就没有编写测试. 暂时也没有文档.

---

本package并不是很"out of the box":

引入本package后需要安装jq, 如果没有相应的pkg-config文件, 编译器就找不到其链接库的位置. 虽然jq在make时会生成pkg-config文件, 但无论手动编译还是使用homebrew安装, 其pkg-config文件都不会被安装, 因此还需要手动处理该文件.

