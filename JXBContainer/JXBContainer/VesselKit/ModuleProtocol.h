//
//  ModuleProtocol.h
//  VesselKitDemo
//
//  Created by apple on 2022/7/17.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ModulePriority) {
    ModulePriorityLow,
    ModulePriorityDefault,
    ModulePriorityMedim,
    ModulePriorityHigh,
    ModulePriorityHigher,
    ModulePriorityHighest,
    ModulePriorityTop
};

@protocol ModuleProtocol <NSObject>

- (ModulePriority)priority;

- (BOOL)asyncInvoke;

- (void)userLoginSuccessEvent;

- (void)userWillLogoutEvent;

- (void)userUserLogoutEvent;

@end
