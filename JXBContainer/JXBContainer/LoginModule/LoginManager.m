//
//  LoginManager.m
//  MagicProject
//
//  Created by 金修博 on 2018/12/3.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "LoginManager.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JXBContainerDefines.h"
#import "LoginViewController.h"

@interface LoginManager ()

@end

@implementation LoginManager

+ (void)showLoginWindow {
    AppDelegate *appDelegate = (AppDelegate *)[JXBContainer shareInstance].context.application.delegate;
    UIWindow *loginWindow = [[UIWindow alloc] initWithFrame:appDelegate.window.frame];
    loginWindow.backgroundColor = [UIColor whiteColor];
    loginWindow.hidden = NO;
    loginWindow.rootViewController = [LoginViewController new];
    loginWindow.windowLevel = normal;
    [appDelegate setLoginWindow:loginWindow];
}

+ (void)loginSuccess:(NSDictionary *)userData {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [JXBContainer triggerEvent:kModUserLoginSuccessEvent customParam:userData];

        AppDelegate *appDelegate = (AppDelegate *)[JXBContainer shareInstance].context.application.delegate;
        LoginViewController *loginVC = (LoginViewController *)appDelegate.loginWindow.rootViewController;
        loginVC.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.loginWindow.hidden = YES;
        app.loginWindow.rootViewController = nil;
        app.loginWindow = nil;
    }];
}

+ (void)logoutSuccess {
    [[JXBModuleManager shareInstance] triggerEvent:kModUserLogoutSuccessEvent];
    
    AppDelegate *appDelegate = (AppDelegate *)[JXBContainer shareInstance].context.application.delegate;
    UIWindow *loginWindow = appDelegate.loginWindow;
    if (!loginWindow) {
        loginWindow = [[UIWindow alloc] initWithFrame:appDelegate.window.frame];
    }
    loginWindow.rootViewController = [LoginViewController new];
    loginWindow.windowLevel = normal;
    CATransition *anim = [[CATransition alloc] init];
    anim.type = kCATransitionMoveIn;
    anim.duration = 0.25f;
    anim.subtype = kCATransitionFromTop;
    [loginWindow.layer addAnimation:anim forKey:nil];
    loginWindow.hidden = NO;
    [appDelegate setLoginWindow:loginWindow];
}

@end
