//
//  JXBModuleManager.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBModuleManager.h"
#import "JXBModuleProtocol.h"
#import "JXBCommon.h"
#import "JXBContext.h"
#import <objc/runtime.h>

NSString * const kModDidFinishLaunchingEvent                        = @"modDidFinishLaunchingEvent:";
NSString * const kModWillResignActiveEvent                          = @"modWillResignActiveEvent:";
NSString * const kModDidBecomeActiveEvent                           = @"modDidBecomeActiveEvent:";
NSString * const kModWillEnterForegroundEvent                       = @"modWillEnterForegroundEvent:";
NSString * const kModDidEnterBackgroundEvent                        = @"modDidEnterBackgroundEvent:";
NSString * const kModWillTerminateEvent                             = @"modWillTerminateEvent:";
NSString * const kModDidReceiveMemoryWarningEvent                   = @"modDidReceiveMemoryWarningEvent:";
NSString * const kModDidRegisterForRemoteNotificationEvent          = @"modDidRegisterForRemoteNotificationEvent:";
NSString * const kModDidRegisterForRemoteNotificationEven           = @"modDidRegisterForRemoteNotificationEvent:";
NSString * const kModDidFailToRegisterForRemoteNotificationEvent    = @"modDidFailToRegisterForRemoteNotificationEvent:";
NSString * const kModDidReceiveRemoteNotificationEvent              = @"modDidReceiveRemoteNotificationEvent:";
NSString * const kModDidReceiveNotificationResponseEvent            = @"modDidReceiveNotificationResponseEvent:";
NSString * const kModDidReceiveLocalNotificationEvent               = @"modDidReceiveLocalNotificationEvent:";
NSString * const kModCustomEvent                                    = @"modCustomEvent:";
NSString * const kModSystemEvent                                    = @"modSystemEvent:";
NSString * const kModOpenURLEvent                                   = @"modOpenURLEvent:";
NSString * const kModInstallEvent                                   = @"modInstallEvent:";
NSString * const kModInitEvent                                      = @"modInitEvent:";
NSString * const kModUninstallEvent                                 = @"modUninstallEvent:";
NSString * const kModUserLoginSuccessEvent                          = @"modUserLoginSuccessEvent:";
NSString * const kModUserLoginFailEvent                             = @"modUserLoginFailEvent:";
NSString * const kModUserLogoutSuccessEvent                         = @"modUserLogoutSuccessEvent:";
NSString * const kModUserLogoutFailEvent                            = @"modUserLogoutFailEvent:";
NSString * const kModUserAbnormalSignoutEvent                       = @"modUserAbnormalSignoutEvent:";
NSString * const kModUserActiveEvent                                = @"modUserActiveEvent:";
NSString * const kModShortcutActionEvent                            = @"modShortcutActionEvent:";
NSString * const kModDidUpdateUserActivityEvent                     = @"modDidUpdateUserActivityEvent:";
NSString * const kModDidFailToContinueUserActivityEvent             = @"modDidFailToContinueUserActivityEvent:";
NSString * const kModContinueUserActivityEvent                      = @"modContinueUserActivityEvent:";
NSString * const kModWillContinueUserActivityEvent                  = @"modWillContinueUserActivityEvent:";
NSString * const kModHandleWatchKitExtensionRequestEvent            = @"modHandleWatchKitExtensionRequestEvent:";

@interface JXBModuleManager ()
@property(nonatomic, strong) NSMutableArray *modules;
@property(nonatomic, strong) NSMutableSet *selectorByEvent;
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<id<JXBModuleProtocol>> *> *modulesByEvent;
@end

@implementation JXBModuleManager

+ (instancetype)shareInstance {
    static JXBModuleManager *manager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        //...
    }
    return self;
}

- (void)registerModule:(Class)moduleClass {
    if (!moduleClass) return;
    
    NSString *moduleName = NSStringFromClass(moduleClass);
    
    if ([moduleClass conformsToProtocol:@protocol(JXBModuleProtocol)]) {
        //实例化
        id<JXBModuleProtocol> moduleInstance = [[moduleClass alloc] init];
        [self.modules addObject:moduleInstance];
        
        MagicLog(@"%@模块初始化完成.", NSStringFromClass(moduleClass));
        
        //注册事件-模块映射表
        [self registerEventWithModuleInstance:moduleInstance];
    }else{
        MagicLog(@">>>JXBContainerError:[%@]没有实现JXBModuleProtocol协议", moduleName);
    }
}

- (void)registerEventWithModuleInstance:(id<JXBModuleProtocol>)moduleInstance {
    NSArray<NSString *> *events = self.selectorByEvent.allObjects;

    //遍历所有事件,创建事件-模块映射关系
    [events enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self registerEvent:obj withModuleInstance:moduleInstance];
    }];
}

- (void)registerEvent:(NSString *)event withModuleInstance:(id<JXBModuleProtocol>)moduleInstance {
    NSParameterAssert(event);
    if (!event) return;
    SEL selector = NSSelectorFromString(event);
    if(!selector) return;

    if (![self.selectorByEvent containsObject:event]) {
        //如果eventType类型不存在就添加到事件字典中,为的是扩充自定义事件类型
        [self.selectorByEvent addObject:event];
    }
    if (!self.modulesByEvent[event]) {
        [self.modulesByEvent setObject:@[].mutableCopy forKey:event];
    }
    NSMutableArray *modulesOfEvent = [self.modulesByEvent objectForKey:event];

    if (![modulesOfEvent containsObject:moduleInstance]) {
        [modulesOfEvent addObject:moduleInstance];

        [modulesOfEvent sortUsingComparator:^NSComparisonResult(id<JXBModuleProtocol> module1, id<JXBModuleProtocol> module2) {
            NSInteger module1Priority = 0;
            NSInteger module2Priority = 0;
            if ([module1 respondsToSelector:@selector(priority)]) {
                module1Priority = [module1 priority];
            }
            if ([module2 respondsToSelector:@selector(priority)]) {
                module2Priority = [module2 priority];
            }
            return module1Priority < module2Priority;
        }];
    }
}


- (void)unregisterModuleWithModule:(Class)moduleClass {
    if (!moduleClass) return;
    
    //modules删除moduleClass对应的module
    __block NSInteger index = -1;
    [self.modules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:moduleClass]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index >= 0) {
        [self.modules removeObjectAtIndex:index];
    }
    
    //模块-事件映射表删除moduleClass对应的module
    [self.modulesByEvent enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray<id<JXBModuleProtocol>> * _Nonnull obj, BOOL * _Nonnull stop) {
        __block NSInteger index = -1;
        
        [obj enumerateObjectsUsingBlock:^(id<JXBModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:moduleClass]) {
                index = idx;
                *stop = YES;
            }
        }];
        
        if (index >= 0) {
            [obj removeObjectAtIndex:index];
        }
    }];
}

- (void)registerCustomEvent:(NSString *)event withModuleInstance:(id<JXBModuleProtocol>)moduleInstance {
    [self registerEvent:event withModuleInstance:moduleInstance];
}

#pragma mark - 触发事件
- (void)triggerEvent:(NSString *)event {
    [self triggerEvent:event customParam:nil];
}

- (void)triggerEvent:(NSString *)event customParam:(NSDictionary *)customParam {
    [self triggerModuleEvent:event withTarget:nil withCustomParam:customParam];
}

- (void)triggerModuleEvent:(NSString *)event
                withTarget:(id<JXBModuleProtocol>)target
           withCustomParam:(NSDictionary *)customParam {
    
    if ([event isEqualToString:kModInstallEvent]) {
        [self triggerModuleInstallEventWithTarget:target withCustomParam:customParam];
    }else if ([event isEqualToString:kModInitEvent]) {
        [self triggerModuleInitEventWithTarget:target withCustomParam:customParam];
    } else if ([event isEqualToString:kModUninstallEvent]) {
        [self triggerModuleUninstallEventWithTarget:target withCustomParam:customParam];
    } else {
        [self triggerModuleCommonEvent:event withTarget:target withCustomParam:customParam];
    }
}

- (void)triggerModuleInstallEventWithTarget:(id<JXBModuleProtocol>)target withCustomParam:(NSDictionary *)customParam {
    //根据优先级排序
    [self.modules sortUsingComparator:^NSComparisonResult(id<JXBModuleProtocol> module1, id<JXBModuleProtocol> module2) {
        NSInteger module1Priority = 0;
        NSInteger module2Priority = 0;
        if ([module1 respondsToSelector:@selector(priority)]) {
            module1Priority = [module1 priority];
        }
        if ([module2 respondsToSelector:@selector(priority)]) {
            module2Priority = [module2 priority];
        }
        return module1Priority < module2Priority;
    }];
    
    NSArray<id<JXBModuleProtocol>> *moduleInstances;
    if (target) {
        moduleInstances = @[target];
    }else{
        moduleInstances = [self.modulesByEvent objectForKey:kModInstallEvent];
    }
    
    [self triggerModuleCommonEvent:kModInstallEvent withTarget:target withCustomParam:customParam];
}

- (void)triggerModuleInitEventWithTarget:(id<JXBModuleProtocol>)target withCustomParam:(NSDictionary *)customParam {
    NSArray<id<JXBModuleProtocol>> *moduleInstances;
    if (target) {
        moduleInstances = @[target];
    }else{
        moduleInstances = [self.modulesByEvent objectForKey:kModInitEvent];
    }
    
    JXBContext *context = [JXBContext shareInstance].copy;
    context.customEvent = kModInitEvent;
    context.customParam = customParam;
    
    [moduleInstances enumerateObjectsUsingBlock:^(id<JXBModuleProtocol>  _Nonnull moduleInstance, NSUInteger idx, BOOL * _Nonnull stop) {
        __weak typeof(self) weakSelf = self;
        void (^callback)(void);
        callback = ^(){
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                if ([moduleInstance respondsToSelector:@selector(modInitEvent:)]) {
                    [moduleInstance modInitEvent:context];
                }
            }
        };
       
        if ([moduleInstance respondsToSelector:@selector(async)]) {
            BOOL async = [moduleInstance async];
            
            if (async) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback();
                });
            }else{
                callback();
            }
        }else{
            callback();
        }
    }];
}

- (void)triggerModuleUninstallEventWithTarget:(id<JXBModuleProtocol>)target withCustomParam:(NSDictionary *)customParam {
    NSArray<id<JXBModuleProtocol>> *moduleInstances;
    if (target) {
        moduleInstances = @[target];
    }else{
        moduleInstances = [self.modulesByEvent objectForKey:kModUninstallEvent];
    }
    
    JXBContext *context = [JXBContext shareInstance].copy;
    context.customEvent = kModUninstallEvent;
    context.customParam = customParam;
    
    [moduleInstances enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<JXBModuleProtocol>  _Nonnull moduleInstance, NSUInteger idx, BOOL * _Nonnull stop) {
        if (moduleInstance && [moduleInstance respondsToSelector:@selector(modUninstallEvent:)]) {
            [moduleInstance modUninstallEvent:context];
        }
    }];
}

- (void)triggerModuleCommonEvent:(NSString *)eventType
                      withTarget:(id<JXBModuleProtocol>)target
                 withCustomParam:(NSDictionary *)customParam {
    if (!eventType) return;
    if (![self.selectorByEvent containsObject:eventType]) return;
    SEL selector = NSSelectorFromString(eventType);
    NSArray<id<JXBModuleProtocol>> *moduleInstances;
    if (target) {
        moduleInstances = @[target];
    }else{
        moduleInstances = [self.modulesByEvent objectForKey:eventType];
    }
    
    JXBContext *context = [JXBContext shareInstance].copy;
    context.customEvent = eventType;
    context.customParam = customParam;
    
    [moduleInstances enumerateObjectsUsingBlock:^(id<JXBModuleProtocol>  _Nonnull moduleInstance, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([moduleInstance respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [moduleInstance performSelector:selector withObject:context];
#pragma clang diagnostic pop
        }
    }];
}


#pragma mark - property getter
- (NSMutableArray *)modules {
    if (!_modules) {
        _modules = [NSMutableArray array];
    }
    return _modules;
}

- (NSMutableDictionary<NSString *,NSMutableArray<id<JXBModuleProtocol>> *> *)modulesByEvent {
    if (!_modulesByEvent) {
        _modulesByEvent = [NSMutableDictionary dictionary];
    }
    return _modulesByEvent;
}

- (NSMutableSet *)selectorByEvent {
    if (!_selectorByEvent) {
        _selectorByEvent = [NSMutableSet set];
        NSSet *blackSelList = [NSSet setWithObjects:@"priority", @"async", nil];
        
        unsigned int numberOfMethods = 0;
        struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(@protocol(JXBModuleProtocol), NO, YES, &numberOfMethods);
        for (unsigned int i = 0; i < numberOfMethods; ++i) {
            struct objc_method_description methodDescription = methodDescriptions[i];
            SEL selector = methodDescription.name;
            if (! class_getInstanceMethod([self class], selector)) {
                NSString *selectorString = [NSString stringWithCString:sel_getName(selector) encoding:NSUTF8StringEncoding];
                if (![blackSelList containsObject:selectorString]) {
                    [_selectorByEvent addObject:selectorString];
                }
            }
        }
    }
    return _selectorByEvent;
}


@end
