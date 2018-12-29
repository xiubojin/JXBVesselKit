//
//  CRMModule.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "CRMModule.h"
#import "JXBContainerDefines.h"

@interface CRMModule ()<JXBModuleProtocol>

@end

@implementation CRMModule
container_module_register_async(YES)

- (JXBModulePriority)priority {
    return 0;
}

- (void)modInitEvent:(JXBContext *)context {
    NSLog(@"CRMModule modInitEvent");
}


@end
