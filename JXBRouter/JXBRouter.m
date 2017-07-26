//
//  JXBRouter.m
//  JXBRoterExample
//
//  Created by 金修博 on 2017/7/24.
//  Copyright © 2017年 huber. All rights reserved.
//

#import "JXBRouter.h"
#import <objc/runtime.h>

#define PushTargetController(targetVC) [[JXBRouter sharedJXBRouter].currentNavigationController pushViewController:targetVC animated:YES];

@class JXBRouter;

#pragma mark - UIViewController+JXBRouter
@implementation UIViewController (JXBRouter)

static char kAssociatedParamsObjectKey;

- (HandlerBlock)handlerBlock {
    return  objc_getAssociatedObject(self, &kAssociatedParamsObjectKey);
}

- (void)setHandlerBlock:(HandlerBlock)handlerBlock {
    objc_setAssociatedObject(self, &kAssociatedParamsObjectKey, handlerBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark - UINavigationController+JXBRouter

@interface UINavigationController (JXBRouter)

@end

@implementation UINavigationController (JXBRouter)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        swizzleMethod(class, @selector(viewWillAppear:), @selector(aop_NavigationViewWillAppear:));
    });
}

- (void)aop_NavigationViewWillAppear:(BOOL)animation {
    [self aop_NavigationViewWillAppear:animation];
    
    [JXBRouter sharedJXBRouter].currentNavigationController = self;
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end


#pragma mark - JXBRouter

@interface JXBRouter ()
@property(nonatomic,strong) NSMutableDictionary *routes;
@end

@implementation JXBRouter

#pragma mark - class method

+ (instancetype)sharedJXBRouter {
    static JXBRouter *router = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!router) {
            router = [[self alloc] init];
        }
    });
    return router;
}

+ (void)registerRoutePattern:(NSString *)routePattern targetControllerName:(NSString *)targetControllerName {
    [self registerRoutePattern:routePattern targetControllerName:targetControllerName handler:nil];
}

+ (void)registerRoutePattern:(NSString *)routePattern targetControllerName:(NSString *)targetControllerName handler:(void(^)(NSString *handlerTag, id parameters))handlerBlock {
    
    if (!routePattern.length && !targetControllerName.length) return;
    
    [[self sharedJXBRouter] addRoutePattern:routePattern targetControllerName:targetControllerName handler:handlerBlock];
}

+ (void)deregisterRoutePattern:(NSString *)routePattern {
    [[self sharedJXBRouter] removeRoutePattern:routePattern];
}

+ (void)deregisterRoutePatternWithController:(Class)class {
    [[self sharedJXBRouter] removeRoutePatternWithController:class];
}

+ (BOOL)startRoute:(NSString *)routePattern {
    
    if (!routePattern.length) return NO;
    
    NSURL *URL = [NSURL URLWithString:[routePattern stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    return [self startRouteWithURL:URL];
}

+ (BOOL)startRouteWithURL:(NSURL *)URL {
    if (!URL) return NO;
    
    return [self analysisRoutePattern:URL];
}

+ (BOOL)analysisRoutePattern:(NSURL *)URL{
    
    NSString *routePattern = [URL absoluteString];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:routePattern];
    
    NSString *scheme = components.scheme;
    
    //scheme规则自己添加
    if (![scheme isEqualToString:@"demo"]) {
        NSLog(@"scheme规则不匹配");
        return NO;
    }
    
    if (components.host.length > 0 && (![components.host isEqualToString:@"localhost"] && [components.host rangeOfString:@"."].location == NSNotFound)) {
        NSString *host = [components.percentEncodedHost copy];
        components.host = @"/";
        components.percentEncodedPath = [host stringByAppendingPathComponent:(components.percentEncodedPath ?: @"")];
    }
    
    NSString *path = [components percentEncodedPath];
    
    if (components.fragment != nil) {
        BOOL fragmentContainsQueryParams = NO;
        NSURLComponents *fragmentComponents = [NSURLComponents componentsWithString:components.percentEncodedFragment];
        
        if (fragmentComponents.query == nil && fragmentComponents.path != nil) {
            fragmentComponents.query = fragmentComponents.path;
        }
        
        if (fragmentComponents.queryItems.count > 0) {
            fragmentContainsQueryParams = fragmentComponents.queryItems.firstObject.value.length > 0;
        }
        
        if (fragmentContainsQueryParams) {
            components.queryItems = [(components.queryItems ?: @[]) arrayByAddingObjectsFromArray:fragmentComponents.queryItems];
        }
        
        if (fragmentComponents.path != nil && (!fragmentContainsQueryParams || ![fragmentComponents.path isEqualToString:fragmentComponents.query])) {
            path = [path stringByAppendingString:[NSString stringWithFormat:@"#%@", fragmentComponents.percentEncodedPath]];
        }
    }
    
    if (path.length > 0 && [path characterAtIndex:0] == '/') {
        path = [path substringFromIndex:1];
    }
    
    if (path.length > 0 && [path characterAtIndex:path.length - 1] == '/') {
        path = [path substringToIndex:path.length - 1];
    }
    
    //获取queryItem
    NSArray <NSURLQueryItem *> *queryItems = [components queryItems] ?: @[];
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in queryItems) {
        if (item.value == nil) {
            continue;
        }
        
        if (queryParams[item.name] == nil) {
            queryParams[item.name] = item.value;
        } else if ([queryParams[item.name] isKindOfClass:[NSArray class]]) {
            NSArray *values = (NSArray *)(queryParams[item.name]);
            queryParams[item.name] = [values arrayByAddingObject:item.value];
        } else {
            id existingValue = queryParams[item.name];
            queryParams[item.name] = @[existingValue, item.value];
        }
    }

    NSDictionary *params = queryParams.copy;
    
    return [[self sharedJXBRouter] pushTargetControllerWithRoutePattern:&routePattern queryParams:&params];
}

#pragma mark - instance method
- (void)addRoutePattern:(NSString *)routePattern targetControllerName:(NSString *)targetControllerName handler:(void (^)(NSString *, id))handlerBlock {
    if (!routePattern.length && !targetControllerName.length) return;
    
    NSArray *pathComponents = [self pathComponentsFromRoutePattern:routePattern];
    
    if (pathComponents.count > 1) {
        //for example:demo.Amodule.product.detail
        NSString *components = [pathComponents componentsJoinedByString:@"."];
        
        NSMutableDictionary *routes = self.routes;
        
        if (![routes objectForKey:routePattern]) {
            NSMutableDictionary *controllerHandler = [NSMutableDictionary dictionary];
            if (handlerBlock) {
                [controllerHandler setValue:[handlerBlock copy] forKey:targetControllerName];
                routes[components] = controllerHandler;
            }else{
                routes[components] = targetControllerName;
            }
        }
    }
    
}

- (void)removeRoutePattern:(NSString *)routePattern {
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[self pathComponentsFromRoutePattern:routePattern]];
    
    if (pathComponents.count >= 1) {
        NSString *components = [pathComponents componentsJoinedByString:@"."];
        
        NSMutableDictionary *routes = self.routes;
        
        if ([routes objectForKey:components]) {
            [routes removeObjectForKey:components];
        }
    }
}

- (void)removeRoutePatternWithController:(Class)class {
    NSString *classString = NSStringFromClass(class);
    
    [self.routes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *targetControllerName = nil;
        
        if ([obj isKindOfClass:[NSString class]]) {
            targetControllerName = (NSString *)obj;
        }else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *controllerHandler = (NSDictionary *)obj;
            targetControllerName = controllerHandler.allKeys.firstObject;
        }
        
        if ([targetControllerName isEqualToString:classString]) {
            [self.routes removeObjectForKey:key];
            
            *stop = YES;
        }
    }];
}

- (NSArray *)pathComponentsFromRoutePattern:(NSString*)routePattern {
    NSMutableArray *pathComponents = [NSMutableArray array];
    
    if ([routePattern rangeOfString:@"://"].location != NSNotFound) {
        
        NSArray *pathSegments = [routePattern componentsSeparatedByString:@"://"];
        
        [pathComponents addObject:pathSegments[0]];
        
        routePattern = pathSegments.lastObject;
        if (!routePattern.length) {
            [pathComponents addObject:@"~"];
        }
    }
    
    for (NSString *pathComponent in [[NSURL URLWithString:routePattern] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    
    return [pathComponents copy];
}

- (BOOL)pushTargetControllerWithRoutePattern:(NSString **)routePattern queryParams:(NSDictionary **)queryParams {
    
    BOOL canOpen = NO;
    
    NSString *targetRoutePattern = *routePattern;
    
    NSDictionary *targetQueryParams = *queryParams;
    
    NSArray *pathComponents = [self pathComponentsFromRoutePattern:targetRoutePattern];
    
    NSString *components = [pathComponents componentsJoinedByString:@"."];
    
    id routesValue = self.routes[components];
    
    NSString *targetControllerName = nil;
    NSDictionary *controllerHandler = nil;
    
    if ([routesValue isKindOfClass:[NSString class]]) {
        targetControllerName = (NSString *)routesValue;
    }else if ([routesValue isKindOfClass:[NSDictionary class]]) {
        controllerHandler = (NSDictionary *)routesValue;
        targetControllerName = controllerHandler.allKeys.firstObject;
    }
    
    Class targetClass = NSClassFromString(targetControllerName);
    
    SEL selector = NSSelectorFromString(@"createViewController:");
    
    if ([targetClass respondsToSelector:selector]) {
        
        UIViewController *targetController = [targetClass createViewController:targetQueryParams];
        
        if (targetController) {
            if (controllerHandler) {
                HandlerBlock handlerBlock = [controllerHandler valueForKey:targetControllerName];
                
                if (handlerBlock) {
                    targetController.handlerBlock = handlerBlock;
                }
            }
            
            //push
            PushTargetController(targetController);
            
            canOpen = YES;
        }else{
            NSLog(@"未找到相关类!");
        }
    }else{
        NSString *errorInfo = [NSString stringWithFormat:@"请让目标控制器遵守JXBRouter的JXBRouterProtocol协议"];
        NSLog(@"%@",errorInfo);
    }
    
    return canOpen;
}

#pragma mark - 其他
- (NSMutableDictionary *)routes {
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}

@end
