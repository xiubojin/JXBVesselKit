//
//  JXBRouter+CRM.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/28.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBRouter+CRM.h"
#import "CRMViewController.h"

@implementation JXBRouter (CRM)
+ (UIViewController *)crmViewControllerWithParam:(NSDictionary *)param {
    NSString *JXBg = param[@"message"];
    NSParameterAssert(JXBg);
    CRMViewController *vc = [CRMViewController new];
    vc.message = JXBg;
    return vc;
}
@end
