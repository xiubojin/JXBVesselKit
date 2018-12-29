//
//  SettingModule.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "SettingModule.h"
#import "JXBRouter+Setting.h"
#import "JXBContainerDefines.h"

@interface SettingModule ()<JXBModuleProtocol>

@end

@implementation SettingModule
container_module_register

- (void)modDidEnterBackgroundEvent:(JXBContext *)context {
    NSLog(@"SettingModule - DidEnterBackgroundEvent");
}

- (void)modInstallEvent:(JXBContext *)context {
    [[JXBModuleManager shareInstance] registerCustomEvent:@"mod58PushMessageEvent:" withModuleInstance:self];
}

- (JXBModulePriority)priority {
    return 4;
}

- (void)modInitEvent:(JXBContext *)context {
    NSLog(@"SettingModule modInitEvent");
    id<SettingViewControllerProtocol> settingVC = [JXBRouter settingViewControllerWithParam:nil];
    [JXBContainer addModuleServiceInstance:settingVC serviceName:NSStringFromClass([self class])];
}

- (void)mod58PushMessageEvent:(JXBContext *)context {
    NSLog(@"SettingModule - 58PushMessage - param = %@",context.customParam);
}

- (void)modCustomEvent:(JXBContext *)context {
    id<SettingViewControllerProtocol> settingVC = [JXBContainer getModuleServiceInstanceWithServiceName:NSStringFromClass([self class])];
    NSString *title = context.customParam[@"title"];
    [settingVC changeTitle:title];
}

- (void)modUserLoginSuccessEvent:(JXBContext *)context {
    NSLog(@"SettingModule - modUserLoginSuccessEvent.customParam = %@", context.customParam);
}

- (void)modUserLogoutSuccessEvent:(JXBContext *)context {
    NSLog(@"SettingModule - modUserLogoutSuccessEvent");
}
@end
