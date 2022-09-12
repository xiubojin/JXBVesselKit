//
//  ServiceProtocol.h
//  VesselKitDemo
//
//  Created by apple on 2022/7/18.
//

#import <Foundation/Foundation.h>

@protocol ServiceProtocol <NSObject>

@optional
+ (id)sharedInstance;
- (BOOL)shouldCache;
- (void)reuseCache;

@required
- (void)startup;

@end
