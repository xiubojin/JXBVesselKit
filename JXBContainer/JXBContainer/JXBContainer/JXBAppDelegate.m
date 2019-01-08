//
//  JXBAppDelegate.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/28.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBAppDelegate.h"
#import "JXBContainerDefines.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
@interface JXBAppDelegate ()<UNUserNotificationCenterDelegate>
#else
@interface JXBAppDelegate ()
#endif

@end


@implementation JXBAppDelegate

@synthesize window;

#pragma mark - Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[JXBModuleManager shareInstance] triggerEvent:kModInstallEvent];
    [[JXBModuleManager shareInstance] triggerEvent:kModInitEvent];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[JXBModuleManager shareInstance] triggerEvent:kModWillResignActiveEvent];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[JXBModuleManager shareInstance] triggerEvent:kModDidBecomeActiveEvent];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[JXBModuleManager shareInstance] triggerEvent:kModWillEnterForegroundEvent];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[JXBModuleManager shareInstance] triggerEvent:kModDidEnterBackgroundEvent];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[JXBModuleManager shareInstance] triggerEvent:kModWillTerminateEvent];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[JXBModuleManager shareInstance] triggerEvent:kModDidReceiveMemoryWarningEvent];
}

#pragma mark - Push Notification
//注册推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[JXBContainer shareInstance].context.notificationItem setReigsterError:error];
    [[JXBModuleManager shareInstance] triggerEvent:kModDidFailToRegisterForRemoteNotificationEvent];
}

//注册推送获取deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[JXBContainer shareInstance].context.notificationItem setDeviceToken:deviceToken];
    [[JXBModuleManager shareInstance] triggerEvent:kModDidRegisterForRemoteNotificationEvent];
}

//iOS10以下远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[JXBContainer shareInstance].context.notificationItem setUserInfo:userInfo];
    [[JXBModuleManager shareInstance] triggerEvent:kModDidReceiveRemoteNotificationEvent];
}

//iOS10以下本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[JXBContainer shareInstance].context.notificationItem setLocalNotification:notification];
    [[JXBModuleManager shareInstance] triggerEvent:kModDidReceiveLocalNotificationEvent];
}

//iOS10以上推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    [[JXBContainer shareInstance].context.notificationItem setCenter:center];
    [[JXBContainer shareInstance].context.notificationItem setNotificationResponse:response];
    [[JXBContainer shareInstance].context.notificationItem setNotificationCompletionHandler:completionHandler];
    [[JXBModuleManager shareInstance] triggerEvent:kModDidReceiveNotificationResponseEvent];
}

#pragma mark - Open URL
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[JXBContainer shareInstance].context.openUrlItem setOpenURL:url];
    [[JXBModuleManager shareInstance] triggerEvent:kModOpenURLEvent];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[JXBContainer shareInstance].context.openUrlItem setOpenURL:url];
    [[JXBContainer shareInstance].context.openUrlItem setOptions:options];
    [[JXBModuleManager shareInstance] triggerEvent:kModOpenURLEvent];
    return YES;
}

#pragma mark - Shortcut Action
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80400
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    [[JXBContainer shareInstance].context.shortcutItem setShortcutItem:shortcutItem];
    [[JXBContainer shareInstance].context.shortcutItem setScompletionHandler:completionHandler];
    [[JXBModuleManager shareInstance] triggerEvent:kModShortcutActionEvent];
}
#endif

#pragma mark - User Activity
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[JXBContainer shareInstance].context.userActivityItem setUserActivity:userActivity];
        [[JXBModuleManager shareInstance] triggerEvent:kModDidUpdateUserActivityEvent];
    }
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[JXBContainer shareInstance].context.userActivityItem setUserActivityType:userActivityType];
        [[JXBContainer shareInstance].context.userActivityItem setUserActivityError:error];
        [[JXBModuleManager shareInstance] triggerEvent:kModDidFailToContinueUserActivityEvent];
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[JXBContainer shareInstance].context.userActivityItem setUserActivity:userActivity];
        [[JXBContainer shareInstance].context.userActivityItem setRestorationHandler:restorationHandler];
        [[JXBModuleManager shareInstance] triggerEvent:kModContinueUserActivityEvent];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[JXBContainer shareInstance].context.userActivityItem setUserActivityType:userActivityType];
        [[JXBModuleManager shareInstance] triggerEvent:kModWillContinueUserActivityEvent];
    }
    return YES;
}
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply {
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[JXBContainer shareInstance].context.watchItem setUserInfo:userInfo];
        [[JXBContainer shareInstance].context.watchItem setReplyHandler:reply];
        [[JXBModuleManager shareInstance] triggerEvent:kModHandleWatchKitExtensionRequestEvent];
    }
}
#endif

@end
