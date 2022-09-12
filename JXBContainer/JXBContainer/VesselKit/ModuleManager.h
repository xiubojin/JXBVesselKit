//
//  VesselModuleManager.h
//  VesselKitDemo
//
//  Created by apple on 2022/7/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol ModuleProtocol;
typedef NSString *ModuleEvent;

@interface ModuleManager : NSObject

+ (instancetype)sharedInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)int NS_UNAVAILABLE;

- (void)registerModule:(Class)moduleClass;
- (void)registerCustomEvent:(NSString *)event withModuleInstance:(id<ModuleProtocol>)moduleInstance;
- (void)triggerEvent:(ModuleEvent)event;
- (BOOL)proxyCanResponseToSelector:(SEL)selector;
- (void)proxyForwardInvocation:(NSInvocation *)invocation;

@end
