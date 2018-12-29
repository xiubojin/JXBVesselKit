//
//  IMModule.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "IMModule.h"
#import "JXBRouter+IM.h"
#import "JXBContainerDefines.h"

@interface IMModule ()<JXBModuleProtocol>

@end

@implementation IMModule
container_module_register

- (JXBModulePriority)priority {
    return 4;
}

- (void)modDidEnterBackgroundEvent:(JXBContext *)context {
    NSLog(@"IMModule - DidEnterBackgroundEvent");
}

- (void)modInstallEvent:(JXBContext *)context {
    [[JXBModuleManager shareInstance] registerCustomEvent:@"mod58PushMessageEvent:" withModuleInstance:self];
}

- (void)modInitEvent:(JXBContext *)context {
    NSLog(@"IMModule modInitEvent");
    id<IMViewControllerProtocol> imVC = [JXBRouter imViewControllerWithParam:nil];
    [JXBContainer addModuleServiceInstance:imVC serviceName:NSStringFromClass([self class])];
}

- (void)mod58PushMessageEvent:(JXBContext *)context {
    NSLog(@"IMModule - 58PushMessage - param = %@",context.customParam);
}

- (void)modCustomEvent:(JXBContext *)context {
    id<IMViewControllerProtocol> imVC = [JXBContainer getModuleServiceInstanceWithServiceName:NSStringFromClass([self class])];
    NSString *title = context.customParam[@"title"];
    [imVC changeTitle:title];
}

- (void)modUserLoginSuccessEvent:(JXBContext *)context {
    NSLog(@"IMModule - modUserLoginSuccessEvent.customParam = %@", context.customParam);
}

- (void)modUserLogoutSuccessEvent:(JXBContext *)context {
    NSLog(@"IMModule - modUserLogoutSuccessEvent");
}

@end
