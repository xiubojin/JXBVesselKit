//
//  AppDelegate.m
//  JXBContainer
//
//  Created by 金修博 on 2018/12/29.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarController.h"
#import "LoginManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"--->> application:didFinishLaunchingWithOptions:");
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [TabbarController new];
    [self.window makeKeyAndVisible];
    
    [LoginManager showLoginWindow];
    
    return YES;
}

@end
