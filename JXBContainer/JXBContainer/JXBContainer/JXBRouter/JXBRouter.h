//
//  JXBRouter.h
//  JXBRouterDemo
//
//  Created by 金修博 on 2018/6/18.
//  Copyright © 2018年 金修博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JXBRouter : NSObject

#pragma mark - 当前导航控制器
@property(nonatomic, weak) UINavigationController *currentNavigationController;

#pragma mark - 单例
+ (instancetype)sharedInstance;

#pragma mark - 通过路由地址调用
+ (BOOL)canOpenURL:(NSURL *)URL;
+ (BOOL)openURL:(NSURL *)URL;
+ (BOOL)openURL:(NSURL *)URL withParams:(NSDictionary<NSString *, NSString *> *)params;
+ (BOOL)openURL:(NSURL *)URL
     withParams:(NSDictionary<NSString *, NSString *> *)params
  customHandler:(void(^)(NSString *pathComponentKey, id returnValue))customHandler;

#pragma mark - Target-Action调用
+ (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;

@end
