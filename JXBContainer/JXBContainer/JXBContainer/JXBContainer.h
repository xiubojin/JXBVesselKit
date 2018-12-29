//
//  JXBContainer.h
//  MagicProject
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXBContext.h"

@interface JXBContainer : NSObject

///保存了容器所有数据
@property(nonatomic, strong) JXBContext *context;

+ (instancetype)shareInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

#pragma mark - 模块
+ (void)registerModule:(Class)moduleClass;

#pragma mark - 模块服务
+ (void)addModuleServiceInstance:(id)instance serviceName:(NSString *)serviceName;

+ (id)getModuleServiceInstanceWithServiceName:(NSString *)serviceName;

+ (void)removeModuleServiceInstanceWithServiceName:(NSString *)serviceName;

#pragma mark - 触发事件
+ (void)triggerEvent:(NSString *)eventType;

+ (void)triggerEvent:(NSString *)eventType customParam:(NSDictionary *)param;

@end
