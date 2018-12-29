//
//  JXBRouter+Setting.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBRouter+Setting.h"

@implementation JXBRouter (Setting)

+ (id<SettingViewControllerProtocol>)settingViewControllerWithParam:(NSDictionary *)param {
    return [SettingViewController new];
}

@end
