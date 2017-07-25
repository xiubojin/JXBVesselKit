//
//  JXBRouter.h
//  JXBRoterExample
//
//  Created by 金修博 on 2017/7/24.
//  Copyright © 2017年 huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JXBRouterProtocol <NSObject>

+ (instancetype)createViewController:(id)parameters;

@end

typedef void(^HandlerBlock)(NSString *handlerTag, id results);

@interface JXBRouter : NSObject

@property(nonatomic,strong) UINavigationController *currentNavigationController;

+ (instancetype)sharedJXBRouter;


/**
 注册路由

 @param routePattern 路由规则
 @param targetControllerName 目标控制器名称
 */
+ (void)registerRoutePattern:(NSString *)routePattern targetControllerName:(NSString *)targetControllerName;


/**
 注册路由

 @param routePattern 路由规则
 @param targetControllerName 目标控制器名称
 @param handlerBlock 回调block [handlerTag:回调标记, parameters:回调数据]
 */
+ (void)registerRoutePattern:(NSString *)routePattern targetControllerName:(NSString *)targetControllerName handler:(void(^)(NSString *handlerTag, id parameters))handlerBlock;


/**
 注销路由

 @param routePattern 路由规则
 */
+ (void)deregisterRoutePattern:(NSString *)routePattern;


/**
 注销路由

 @param className Class名称
 */
+ (void)deregisterRoutePatternWithController:(Class)className;


/**
 开始路由

 @param routePattern 路由规则
 @return 是否可以路由
 */
+ (BOOL)startRoute:(NSString *)routePattern;


/**
 开始路由

 @param URL 路由URL
 @return 是否可以路由
 */
+ (BOOL)startRouteWithURL:(NSURL *)URL;

@end

@interface UIViewController (JXBRouter)

@property(nonatomic,copy) HandlerBlock handlerBlock;

@end
