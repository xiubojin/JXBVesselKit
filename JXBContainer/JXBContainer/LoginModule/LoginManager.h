//
//  LoginManager.h
//  JXBContainer
//
//  Created by 金修博 on 2018/12/3.
//  Copyright © 2018 金修博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

+ (void)showLoginWindow;
+ (void)loginSuccess:(NSDictionary *)userData;
+ (void)logoutSuccess;

@end
