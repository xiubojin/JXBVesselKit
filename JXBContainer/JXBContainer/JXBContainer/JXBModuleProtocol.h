//
//  JXBModuleProtocol.h
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXBContext.h"

#define container_module_register \
+ (void)load { [JXBContainer registerModule:[self class]]; } \
- (BOOL)async { return YES; }

//模块注册宏,isAsync=YES时效果同上面那个宏,模块的init事件会异步执行;isAsync=NO时,模块的init事件会同步执行.
#define container_module_register_async(isAsync) \
+ (void)load { [JXBContainer registerModule:[self class]]; } \
- (BOOL)async { return [[NSString stringWithUTF8String:#isAsync] boolValue]; }

typedef NS_ENUM(NSUInteger, JXBModulePriority) {
    JXBModulePriorityDefault,
    JXBModulePriorityNormal,
    JXBModulePriorityHigh,
    JXBModulePriorityHighest
};

@protocol JXBModuleProtocol <NSObject>

#pragma mark - App生命周期事件
@optional
///App启动
- (void)modDidFinishLaunchingEvent:(JXBContext *)context;

///App被挂起
- (void)modWillResignActiveEvent:(JXBContext *)context;

///App被挂起后复原
- (void)modDidBecomeActiveEvent:(JXBContext *)context;

///App进入后台
- (void)modDidEnterBackgroundEvent:(JXBContext *)context;

///App进入前台
- (void)modWillEnterForegroundEvent:(JXBContext *)context;

///App终止
- (void)modWillTerminateEvent:(JXBContext *)context;

///App收到内存警告
- (void)modDidReceiveMemoryWarningEvent:(JXBContext *)context;

#pragma mark - App推送事件
///注册远程推送失败
- (void)modDidFailToRegisterForRemoteNotificationEvent:(JXBContext *)context;

///注册远程推送获取deviceToken
- (void)modDidRegisterForRemoteNotificationEvent:(JXBContext *)context;

///iOS10以下接收到远程推送消息
- (void)modDidReceiveRemoteNotificationEvent:(JXBContext *)context;

///iOS10以下接收到本地推送消息
- (void)modDidReceiveLocalNotificationEvent:(JXBContext *)context;

///iOS10以上接收到推送
- (void)modDidReceiveNotificationResponseEvent:(JXBContext *)context;

#pragma mark - 快捷事件
- (void)modShortcutActionEvent:(JXBContext *)context;

#pragma mark - Apple Watch
- (void)modHandleWatchKitExtensionRequestEvent:(JXBContext *)context;

#pragma mark - User Activity
- (void)modDidUpdateUserActivityEvent:(JXBContext *)context;

- (void)modDidFailToContinueUserActivityEvent:(JXBContext *)context;

- (void)modContinueUserActivityEvent:(JXBContext *)context;

- (void)modWillContinueUserActivityEvent:(JXBContext *)context;

#pragma mark - 其他系统事件
///模块内自定义处理URL
- (void)modOpenURLEvent:(JXBContext *)context;

- (void)modCustomEvent:(JXBContext *)context;

- (void)modSystemEvent:(JXBContext *)context;

#pragma mark - Module生命周期事件
///优先级,取值范围0-3,值越高优先级越高
- (JXBModulePriority)priority;

///安装模块
- (void)modInstallEvent:(JXBContext *)context;

///初始化模块
- (void)modInitEvent:(JXBContext *)context;

///初始化模块工作异步派发到主队列执行（优先级不高的工作这里可以返回YES）
- (BOOL)async;

///卸载模块
- (void)modUninstallEvent:(JXBContext *)context;

#pragma mark - User生命周期事件
///用户登录成功
- (void)modUserLoginSuccessEvent:(JXBContext *)context;

///用户登录失败
- (void)modUserLoginFailEvent:(JXBContext *)context;

///用户退出成功
- (void)modUserLogoutSuccessEvent:(JXBContext *)context;

///用户退出失败
- (void)modUserLogoutFailEvent:(JXBContext *)context;

///用户异常登出
- (void)modUserAbnormalSignoutEvent:(JXBContext *)context;

///用户活跃状态
- (void)modUserActiveEvent:(JXBContext *)context;

@end
