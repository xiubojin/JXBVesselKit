//
//  JXBRouter+Home.h
//  MagicProject
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "JXBRouter.h"
#import "HomeViewController.h"

@interface JXBRouter (Home)

+ (id<HomeViewControllerProtocol>)homeViewControllerWithParam:(NSDictionary *)param;

@end
