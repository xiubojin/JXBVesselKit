//
//  ServiceManager.m
//  VesselKitDemo
//
//  Created by apple on 2022/7/17.
//

#import "ServiceManager.h"
#import <pthread/pthread.h>

@interface ServiceManager ()
@property(nonatomic, strong) NSMutableDictionary *allServicesMdict;
@property(nonatomic, strong) NSMutableDictionary *servicesByName;
@end

@implementation ServiceManager {
    pthread_rwlock_t _serviceMapLock;
    pthread_rwlock_t _serviceNameLock;
}

+ (instancetype)sharedInstance {
    static ServiceManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        pthread_rwlock_init(&_serviceMapLock, NULL);
        pthread_rwlock_init(&_serviceNameLock, NULL);
    }
    return self;
}

- (void)registerServiceWithProtocol:(Protocol *)protocol implClass:(Class)implClass {
    NSParameterAssert(protocol != nil);
    NSParameterAssert(implClass != nil);
    if (![implClass conformsToProtocol:protocol]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ service does not conforms to %@ protocol", NSStringFromClass(implClass), NSStringFromProtocol(protocol)] userInfo:nil];
        return;
    }
    
    if ([self checkServiceIsExist:protocol]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ has been registed.", NSStringFromProtocol(protocol)] userInfo:nil];
        return;
    }
    
    NSString *key = NSStringFromProtocol(protocol);
    NSString *val = NSStringFromClass(implClass);
    if (key.length > 0 && val.length > 0) {
        pthread_rwlock_t *slock = &_serviceMapLock;
        pthread_rwlock_wrlock(slock);
        [self.allServicesMdict addEntriesFromDictionary:@{key : val}];
        pthread_rwlock_unlock(slock);
    }
}

- (id)getService:(Protocol *)service {
    return [self getService:service autoStartup:NO];
}

- (id)getService:(Protocol *)service autoStartup:(BOOL)autoStartup {
    if ([self checkServiceIsExist:service]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ has been registed.", NSStringFromProtocol(service)] userInfo:nil];
    }
    id implInstance = nil;
    NSString *serviceName = NSStringFromProtocol(service);
    implInstance = [self getServiceInstanceWithServiceName:serviceName];
    if (implInstance) {
        if ([implInstance respondsToSelector:@selector(reuseCache)]) {
            [implInstance reuseCache];
        }
        return implInstance;
    }
    
    Class implClass = [self getImplClassWithProtocol:service];
    if (!implClass) return nil;
    if ([implClass respondsToSelector:@selector(shouldCache)]) {
        implInstance = [implClass sharedInstance];
    } else {
        implInstance = [[implClass alloc] init];
    }
    
    if (implInstance && [implInstance respondsToSelector:@selector(shouldCache)]) {
        BOOL shouldCache = [implInstance shouldCache];
        if (shouldCache) {
            [self addServiceInstance:implInstance serviceName:serviceName];
        }
    }
    
    if (implInstance && [implInstance respondsToSelector:@selector(startup)] && autoStartup) {
        [implInstance startup];
    }
    
    return implInstance;
}

- (void)addServiceInstance:(id)implInstance serviceName:(NSString *)seviceName {
    pthread_rwlock_wrlock(&_serviceNameLock);
    [self.servicesByName setObject:implInstance forKey:seviceName];
    pthread_rwlock_unlock(&_serviceNameLock);
}

- (id)getServiceInstanceWithServiceName:(NSString *)serviceName {
    pthread_rwlock_rdlock(&_serviceNameLock);
    id instance = [self.servicesByName objectForKey:serviceName];
    pthread_rwlock_unlock(&_serviceNameLock);
    return instance;
}

- (void)removeServiceInstanceWithServiceName:(NSString *)serviceName {
    pthread_rwlock_wrlock(&_serviceNameLock);
    [self.servicesByName removeObjectForKey:serviceName];
    pthread_rwlock_unlock(&_serviceNameLock);
}

- (Class)getImplClassWithProtocol:(Protocol *)protocol {
    pthread_rwlock_rdlock(&_serviceMapLock);
    NSString *implClsStr = [self.allServicesMdict objectForKey:NSStringFromProtocol(protocol)];
    pthread_rwlock_unlock(&_serviceMapLock);
    if (implClsStr.length > 0) {
        return NSClassFromString(implClsStr);
    }
    return nil;
}

- (BOOL)checkServiceIsExist:(Protocol *)protocol {
    pthread_rwlock_rdlock(&_serviceMapLock);
    NSString *implClsName = [self.allServicesMdict objectForKey:NSStringFromProtocol(protocol)];
    pthread_rwlock_unlock(&_serviceMapLock);
    return implClsName.length > 0;
}

#pragma makr getter
- (NSMutableDictionary *)allServicesMdict {
    if (!_allServicesMdict) {
        _allServicesMdict = [NSMutableDictionary dictionary];
    }
    return _allServicesMdict;
}

- (NSMutableDictionary *)servicesByName {
    if (!_servicesByName) {
        _servicesByName = [NSMutableDictionary dictionary];
    }
    return _servicesByName;
}

- (void)dealloc {
    pthread_rwlock_destroy(&_serviceMapLock);
    pthread_rwlock_destroy(&_serviceNameLock);
}

@end
