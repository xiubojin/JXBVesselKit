//
//  ServiceManager.h
//  VesselKitDemo
//
//  Created by apple on 2022/7/17.
//

#import <Foundation/Foundation.h>
#import "ServiceProtocol.h"

@interface ServiceManager : NSObject


+ (instancetype)sharedInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)int NS_UNAVAILABLE;

- (void)registerServiceWithProtocol:(Protocol *)protocol implClass:(Class)implClass;
- (Class)getImplClassWithProtocol:(Protocol *)protocol;

- (id)getService:(Protocol *)service;
- (id)getService:(Protocol *)service autoStartup:(BOOL)autoStartup;
- (void)addServiceInstance:(id)implInstance serviceName:(NSString *)seviceName;
- (void)removeServiceInstanceWithServiceName:(NSString *)serviceName;

@end
