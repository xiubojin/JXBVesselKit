//
//  Service_CRM.m
//  MagicProject
//
//  Created by 金修博 on 2018/11/28.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "Service_CRM.h"
#import "CRMViewController.h"
#import "JXBRouter.h"

@implementation Service_CRM

- (UIViewController *)func_detail:(NSDictionary *)param {
    return [CRMViewController new];
}

@end
