# JXBContainer

### 整体架构

![image](https://github.com/xiubojin/JXBContainer/blob/master/resource/container1.png)

`iOS`容器组件，组件大体分为两部分：
（1）容器组件
（2）路由组件

### 容器组件

负责事件解耦，事件分为`application`生命周期事件和`user`生命周期事件。
`application`生命周期事件包括但不限于app进入前台、进入后台、推送、`OpenURL`等等。
`user`生命周期事件包括但不限于登录成功、登录失败、登出成功、登出失败、自动登录等等。
这些事件由容器统一监听，事件发生后，容器将事件分发给注册到其中的模块。

### 路由组件

负责模块间解耦，底层机制为`target-action`。

### 特性

- 模块开发实现插件化
- 管理模块声明周期，容器统一分发系统&用户事件
- 业务层模块仅依赖容器组件或路由即可