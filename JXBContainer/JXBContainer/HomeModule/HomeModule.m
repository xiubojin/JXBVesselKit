//
//  HomeModule.m
//  MagicProject
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "HomeModule.h"
#import "JXBRouter+Home.h"
#import "JXBContainerDefines.h"
#import "JXBRouter+CRM.h"

NSString * const kMod58PushMessageEvent = @"mod58PushMessageEvent:";

@interface HomeModule ()<JXBModuleProtocol>

@end

@implementation HomeModule

magic_module_register

- (JXBModulePriority)priority {
    return 4;
}

- (void)modDidEnterBackgroundEvent:(JXBContext *)context {
    NSLog(@"HomeModule - DidEnterBackgroundEvent");
}

- (void)modInstallEvent:(JXBContext *)context {
    [[JXBModuleManager shareInstance] registerCustomEvent:kMod58PushMessageEvent withModuleInstance:self];
}

- (void)modInitEvent:(JXBContext *)context {
    NSLog(@"HomeModule modInitEvent");
    id<HomeViewControllerProtocol> homeVC = [JXBRouter homeViewControllerWithParam:nil];
    [JXBContainer addModuleServiceInstance:homeVC serviceName:NSStringFromClass([self class])];
}

- (void)modUninstallEvent:(JXBContext *)context {
    //除了单例服务,其他被卸载时要把Service删除，避免强引用导致内存泄漏
    [JXBContainer removeModuleServiceInstanceWithServiceName:NSStringFromClass([self class])];
}

- (void)modDidReceiveNotificationResponseEvent:(JXBContext *)context {
    NSString *body = context.notificationItem.notificationResponse.notification.request.content.body;
    [JXBRouter openURL:[NSURL URLWithString:body]];
}

- (void)mod58PushMessageEvent:(JXBContext *)context {
    NSLog(@"HomeModule - 58PushMessage - param = %@",context.customParam);
    UIViewController *crmVC = [JXBRouter crmViewControllerWithParam:context.customParam];
    [[JXBRouter sharedInstance].currentNavigationController pushViewController:crmVC animated:YES];
}

- (void)modCustomEvent:(JXBContext *)context {
    id<HomeViewControllerProtocol> homeVC = [JXBContainer getModuleServiceInstanceWithServiceName:NSStringFromClass([self class])];
    NSString *title = context.customParam[@"title"];
    [homeVC updateTitle:title];
}

- (void)modUserLoginSuccessEvent:(JXBContext *)context {
    NSLog(@"HomeModule - modUserLoginSuccessEvent.customParam = %@", context.customParam);
    
    
}

- (void)modUserLogoutSuccessEvent:(JXBContext *)context {
    NSLog(@"HomeModule - modUserLogoutSuccessEvent");
}

@end
