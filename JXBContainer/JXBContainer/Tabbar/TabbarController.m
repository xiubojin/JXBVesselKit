//
//  TabbarController.m
//  MagicProject
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "TabbarController.h"
#import "JXBContainerDefines.h"

@interface TabbarController ()

@end

@implementation TabbarController

- (instancetype)init {
    if (self = [super init]) {
        UIViewController *vc1 = [JXBContainer getModuleServiceInstanceWithServiceName:@"HomeModule"];
        [self registerViewController:vc1 title:@"首页" iconName:nil];
        
        UIViewController *vc2 = [JXBContainer getModuleServiceInstanceWithServiceName:@"IMModule"];
        [self registerViewController:vc2 title:@"聊天" iconName:nil];
        
        UIViewController *vc3 = [JXBContainer getModuleServiceInstanceWithServiceName:@"ContactModule"];
        [self registerViewController:vc3 title:@"联系人" iconName:nil];
        
        UIViewController *vc4 = [JXBContainer getModuleServiceInstanceWithServiceName:@"SettingModule"];
        [self registerViewController:vc4 title:@"设置" iconName:nil];
        
        self.viewControllers = @[
                                 [[UINavigationController alloc] initWithRootViewController:vc1],
                                 [[UINavigationController alloc] initWithRootViewController:vc2],
                                 [[UINavigationController alloc] initWithRootViewController:vc3],
                                 [[UINavigationController alloc] initWithRootViewController:vc4],
                                 ];
    }
    
    return self;
}

- (void)registerViewController:(UIViewController *)vc title:(NSString *)title iconName:(NSString *)iconName {
    vc.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", iconName]];
    vc.tabBarItem.title = title;
    vc.title = title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Tabbar viewDidLoad");
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
