//
//  JXBRouter+IM.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBRouter+IM.h"

@implementation JXBRouter (IM)

+ (id<IMViewControllerProtocol>)imViewControllerWithParam:(NSDictionary *)param {
    return [IMViewController new];
}

@end
