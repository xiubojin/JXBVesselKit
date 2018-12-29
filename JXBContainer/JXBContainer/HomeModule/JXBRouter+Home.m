//
//  JXBRouter+Home.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBRouter+Home.h"

@implementation JXBRouter (Home)

+ (id<HomeViewControllerProtocol>)homeViewControllerWithParam:(NSDictionary *)param {
    return [HomeViewController new];
}

@end
