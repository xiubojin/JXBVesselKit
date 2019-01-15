//
//  JXBContext.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBContext.h"

@interface JXBContext ()
@property(nonatomic, strong) NSMutableDictionary *servicesByModule;
@end

@implementation JXBContext

+ (instancetype)shareInstance {
    static JXBContext *context;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        context = [[self alloc] init];
    });
    
    return context;
}

- (instancetype)init {
    if (self = [super init]) {
        self.openUrlItem = [[JXBOpenUrlItem alloc] init];
        self.notificationItem = [[JXBNotificationItem alloc] init];
        self.shortcutItem = [[JXBShortcutItem alloc] init];
        self.userActivityItem = [[JXBUserActivityItem alloc] init];
        self.watchItem = [[JXBWatchItem alloc] init];
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    JXBContext *context = [[self.class allocWithZone:zone] init];
    context.env = self.env;
    context.application = self.application;
    context.launchOptions = self.launchOptions;
    context.customEvent = self.customEvent;
    context.customParam = self.customParam;
    context.openUrlItem = self.openUrlItem;
    context.notificationItem = self.notificationItem;
    context.shortcutItem = self.shortcutItem;
    context.userActivityItem = self.userActivityItem;
    context.watchItem = self.watchItem;
    return context;
}

- (void)addModuleServiceInstance:(id)instance serviceName:(NSString *)serviceName {
    [[JXBContext shareInstance].servicesByModule setObject:instance forKey:serviceName];
}

- (id)getModuleServiceInstanceWithServiceName:(NSString *)serviceName {
    return [[JXBContext shareInstance].servicesByModule objectForKey:serviceName];
}

- (void)removeModuleServiceInstanceWithServiceName:(NSString *)serviceName {
    [[JXBContext shareInstance].servicesByModule removeObjectForKey:serviceName];
}

#pragma mark - property getter
- (NSMutableDictionary *)servicesByModule {
    if (!_servicesByModule) {
        _servicesByModule = [NSMutableDictionary dictionary];
    }
    return _servicesByModule;
}
@end


#pragma mark - JXBOpenUrlItem
@implementation JXBOpenUrlItem

@end


#pragma mark - JXBNotificationItem
@implementation JXBNotificationItem

@end

#pragma mark - JXBShortcutItem
@implementation JXBShortcutItem

@end

#pragma mark - JXBUserActivityItem
@implementation JXBUserActivityItem

@end

#pragma mark - JXBWatchItem
@implementation JXBWatchItem

@end
