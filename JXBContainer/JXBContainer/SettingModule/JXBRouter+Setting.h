//
//  JXBRouter+Setting.h
//  MagicProject
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBRouter.h"
#import "SettingViewController.h"

@interface JXBRouter (Setting)

+ (id<SettingViewControllerProtocol>)settingViewControllerWithParam:(NSDictionary *)param;

@end
