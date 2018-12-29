//
//  JXBRouter+Contact.h
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBRouter.h"
#import "ContactViewController.h"

@interface JXBRouter (Contact)

+ (id<ContactViewControllerProtocol>)contactViewControllerWithParam:(NSDictionary *)param;

@end
