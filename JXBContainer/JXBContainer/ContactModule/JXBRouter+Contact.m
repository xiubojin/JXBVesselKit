//
//  JXBRouter+Contact.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBRouter+Contact.h"

@implementation JXBRouter (Contact)

+ (id<ContactViewControllerProtocol>)contactViewControllerWithParam:(NSDictionary *)param {
    return [ContactViewController new];
}

@end
