//
//  JXBContainer.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBContainer.h"
#import "JXBModuleManager.h"
#import "JXBContext.h"

@implementation JXBContainer

+ (instancetype)shareInstance {
    static JXBContainer *container;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        container = [[self alloc] init];
    });
    
    return container;
}

+ (void)registerModule:(Class)moduleClass {
    [[JXBModuleManager shareInstance] registerModule:moduleClass];
}

+ (void)triggerEvent:(NSString *)eventType {
    [[JXBModuleManager shareInstance] triggerEvent:eventType];
}

+ (void)triggerEvent:(NSString *)eventType customParam:(NSDictionary *)param {
    [[JXBModuleManager shareInstance] triggerEvent:eventType customParam:param];
}

+ (void)addModuleServiceInstance:(id)instance serviceName:(NSString *)serviceName {
    [[JXBContext shareInstance] addModuleServiceInstance:instance serviceName:serviceName];
}

+ (id)getModuleServiceInstanceWithServiceName:(NSString *)serviceName {
    return [[JXBContext shareInstance] getModuleServiceInstanceWithServiceName:serviceName];
}

+ (void)removeModuleServiceInstanceWithServiceName:(NSString *)serviceName {
    [[JXBContext shareInstance] removeModuleServiceInstanceWithServiceName:serviceName];
}

@end
