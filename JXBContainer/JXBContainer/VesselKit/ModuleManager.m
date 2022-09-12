//
//  VesselModuleManager.m
//  VesselKitDemo
//
//  Created by apple on 2022/7/17.
//

#import "ModuleManager.h"
#import "ModuleProtocol.h"
#import <objc/runtime.h>
#import "ServiceManager.h"
#import <objc/message.h>
#import <pthread/pthread.h>
#include "vessel_temp_context.hpp"

@interface ModuleManager ()
@property(nonatomic, strong) NSMutableArray *modules;
@property(nonatomic, strong) NSMapTable *modulesByClsName;
@property(nonatomic, strong) NSMutableSet *selectorByEvent;
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<id<ModuleProtocol>> *> *modulesByEvent;
@end

@implementation ModuleManager {
    pthread_rwlock_t _modEventLock;
    pthread_rwlock_t _selEventLock;
}

+ (instancetype)sharedInstance {
    static ModuleManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        pthread_rwlock_init(&_modEventLock, NULL);
        pthread_rwlock_init(&_selEventLock, NULL);
    }
    return self;
}

- (void)containerInit {
    //module
    vector<string> modules = VesselSingleton<TempContext>::instance().get_modules();
    for (string mod : modules) {
        const char *mod_c_str = mod.c_str();
        NSString *clsName = [NSString stringWithUTF8String:mod_c_str];
        if (!clsName) continue;
        Class cls = NSClassFromString(clsName);
        if (cls) [[ModuleManager sharedInstance] registerModule:cls];
    }
    
    //service
    vector<string> services = VesselSingleton<TempContext>::instance().get_services();
    for (string service : services) {
        const char *service_c_str = service.c_str();
        NSString *serviceName = [NSString stringWithUTF8String:service_c_str];
        if (!serviceName) continue;
        NSData *jsonData = [serviceName dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (!error) {
            if ([json isKindOfClass:[NSDictionary class]] && [json allKeys].count) {
                NSString *protocol = [json allKeys][0];
                NSString *implClsName = [json allValues][0];
                if (protocol && implClsName) {
                    [[ServiceManager sharedInstance] registerServiceWithProtocol:NSProtocolFromString(protocol) implClass:NSClassFromString(implClsName)];
                }
            }
        }
    }
}

- (void)registerModule:(Class)moduleClass {
    if (!moduleClass) return;
    NSString *moduleName = NSStringFromClass(moduleClass);
    if ([moduleClass conformsToProtocol:@protocol(ModuleProtocol)]) {
        id<ModuleProtocol> moduleInstance = [[moduleClass alloc] init];
        [self.modules addObject:moduleInstance];
        [self.modules sortUsingComparator:^NSComparisonResult(id<ModuleProtocol> module1, id<ModuleProtocol> module2) {
            ModulePriority module1Priority = ModulePriorityDefault;
            ModulePriority module2Priority = ModulePriorityDefault;
            if ([module1 respondsToSelector:@selector(priority)]) {
                module1Priority = [module1 priority];
            }
            if ([module2 respondsToSelector:@selector(priority)]) {
                module2Priority = [module2 priority];
            }
            return module1Priority < module2Priority ? NSOrderedDescending : NSOrderedAscending;
        }];
        
        [self.modulesByClsName setObject:moduleInstance forKey:moduleName];
        
        [self registerEventWithModuleInstance:moduleInstance];
    } else {
        NSString *errorMsg = [NSString stringWithFormat:@"VesselKit: [%@] done not conform ModuleProtocol.", moduleName];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:errorMsg userInfo:nil];
    }
}
- (void)registerCustomEvent:(NSString *)event withModuleInstance:(id<ModuleProtocol>)moduleInstance {
    [self registerEvent:event withModuleInstance:moduleInstance];
}


- (void)triggerEvent:(ModuleEvent)event {
    if (!event) return;
    if (![self.selectorByEvent containsObject:event]) return;
    SEL selector = NSSelectorFromString(event);
    NSArray<id<ModuleProtocol>> *moduleInstances = [self.modulesByEvent objectForKey:event];
    [moduleInstances enumerateObjectsUsingBlock:^(id<ModuleProtocol>  _Nonnull moduleInstance, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([moduleInstance respondsToSelector:selector]) {
            [moduleInstance performSelector:selector];
        }
    }];
}

- (BOOL)proxyCanResponseToSelector:(SEL)selector {
    static dispatch_once_t initToken;
    dispatch_once(&initToken, ^{
        [self containerInit];
    });
    __block IMP imp = NULL;
    [self.modules enumerateObjectsUsingBlock:^(id<ModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:selector]) {
            imp = [(id)obj methodForSelector:selector];
            NSMethodSignature *signature = [(id)obj methodSignatureForSelector:selector];
            if (signature.methodReturnLength > 0 && strcmp(signature.methodReturnType, @encode(BOOL)) != 0) {
                imp = NULL;
            }
            *stop = YES;
        }
    }];
    return imp != NULL && imp != _objc_msgForward;
}

- (void)proxyForwardInvocation:(NSInvocation *)invocation {
    NSMethodSignature *signature = invocation.methodSignature;
    NSUInteger argCount = signature.numberOfArguments;
    __block BOOL returnValue = NO;
    NSUInteger returnLength = signature.methodReturnLength;
    void *returnValueBytes = NULL;
    if (returnLength > 0) {
        returnValueBytes = alloca(returnLength);
    }
    
    [self.modules enumerateObjectsUsingBlock:^(id<ModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj respondsToSelector:invocation.selector]) {
            return;
        }
        NSInvocation *invok = [NSInvocation invocationWithMethodSignature:signature];
        invok.selector = invocation.selector;
        for (NSUInteger i = 0;i<argCount;i++) {
            const char *argType = [signature getArgumentTypeAtIndex:i];
            NSUInteger argSize = 0;
            NSGetSizeAndAlignment(argType, &argSize, NULL);
            void *argValue = alloca(argSize);
            [invocation getArgument:&argValue atIndex:i];
            [invok setArgument:&argValue atIndex:i];
        }
        invok.target = obj;
        [invok invoke];
        if (returnValueBytes) {
            [invok getReturnValue:returnValueBytes];
            returnValue = returnValue || *((BOOL *)returnValueBytes);
        }
    }];
    if (returnValueBytes) {
        [invocation setReturnValue:returnValueBytes];
    }
}

- (void)registerEventWithModuleInstance:(id<ModuleProtocol>)moduleInstance {
    NSArray<NSString *> *events = self.selectorByEvent.allObjects;
    [events enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self registerEvent:obj withModuleInstance:moduleInstance];
    }];
}

- (void)registerEvent:(ModuleEvent)event withModuleInstance:(id<ModuleProtocol>)moduleInstance {
    NSParameterAssert(event);
    if (!event) return;
    
    SEL selector = NSSelectorFromString(event);
    if (!selector) return;
    
    if (![self.selectorByEvent containsObject:event]) {
        pthread_rwlock_wrlock(&_selEventLock);
        [self.selectorByEvent addObject:event];
        pthread_rwlock_unlock(&_selEventLock);
    }
    
    if (!self.modulesByEvent[event]) {
        pthread_rwlock_wrlock(&_modEventLock);
        [self.modulesByEvent setObject:@[].mutableCopy forKey:event];
        pthread_rwlock_unlock(&_modEventLock);
    }
    
    NSMutableArray *modulesOfEvent = [self.modulesByEvent objectForKey:event];
    if (![modulesOfEvent containsObject:moduleInstance] && [moduleInstance respondsToSelector:selector]) {
        [modulesOfEvent addObject:moduleInstance];
        [modulesOfEvent sortUsingComparator:^NSComparisonResult(id<ModuleProtocol> module1, id<ModuleProtocol> module2) {
            ModulePriority module1Priority = ModulePriorityDefault;
            ModulePriority module2Priority = ModulePriorityDefault;
            if ([module1 respondsToSelector:@selector(priority)]) {
                module1Priority = [module1 priority];
            }
            if ([module2 respondsToSelector:@selector(priority)]) {
                module2Priority = [module2 priority];
            }
            return module1Priority < module2Priority ? NSOrderedDescending : NSOrderedAscending;
        }];
    }
}

#pragma mark - getter
- (NSMutableArray *)modules {
    if (!_modules) {
        _modules = [NSMutableArray array];
    }
    return _modules;
}

- (NSMapTable *)modulesByClsName {
    if (!_modulesByClsName) {
        _modulesByClsName = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSMapTableWeakMemory];
    }
    return _modulesByClsName;
}

- (NSMutableDictionary<NSString *,NSMutableArray<id<ModuleProtocol>> *> *)modulesByEvent {
    if (!_modulesByEvent) {
        _modulesByEvent = [NSMutableDictionary dictionary];
    }
    return _modulesByEvent;
}

- (NSMutableSet *)selectorByEvent {
    if (!_selectorByEvent) {
        _selectorByEvent = [NSMutableSet set];
        NSSet *notMatchSel = [NSSet setWithObjects:@"priority", @"async", nil];
        unsigned int numberOfMethods = 0;
        struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(@protocol(ModuleProtocol), NO, YES, &numberOfMethods);
        for (unsigned int i = 0;i<numberOfMethods;++i) {
            struct objc_method_description methodDescription = methodDescriptions[i];
            SEL selector = methodDescription.name;
            if (!class_getInstanceMethod(self.class, selector)) {
                NSString *selectorString = [NSString stringWithCString:sel_getName(selector) encoding:NSUTF8StringEncoding];
                if (![notMatchSel containsObject:selectorString]) {
                    [_selectorByEvent addObject:selectorString];
                }
            }
        }
    }
    return _selectorByEvent;
}

- (void)dealloc {
    pthread_rwlock_destroy(&_modEventLock);
    pthread_rwlock_destroy(&_selEventLock);
}

@end
