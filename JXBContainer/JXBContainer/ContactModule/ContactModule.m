//
//  ContactModule.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "ContactModule.h"
#import "JXBRouter+Contact.h"
#import "JXBContainerDefines.h"

@ContainerMod(ContactModule)
@interface ContactModule ()<JXBModuleProtocol>

@end


@implementation ContactModule

- (JXBModulePriority)priority {
    return 4;
}


- (void)modInitEvent:(JXBContext *)context {
    NSLog(@"ContactModule modInitEvent");
    id<ContactViewControllerProtocol> contactVC = [JXBRouter contactViewControllerWithParam:nil];
    [JXBContainer addModuleServiceInstance:contactVC serviceName:NSStringFromClass([self class])];
}

- (void)modCustomEvent:(JXBContext *)context {
    id<ContactViewControllerProtocol> contactVC = [JXBContainer getModuleServiceInstanceWithServiceName:NSStringFromClass([self class])];
    NSString *title = context.customParam[@"title"];
    [contactVC changeTitle:title];
}

- (void)modUserLoginSuccessEvent:(JXBContext *)context {
    NSLog(@"ContactModule - modUserLoginSuccessEvent.customParam = %@", context.customParam);
}

- (void)modUserLogoutSuccessEvent:(JXBContext *)context {
    NSLog(@"ContactModule - modUserLogoutSuccessEvent");
}


@end
