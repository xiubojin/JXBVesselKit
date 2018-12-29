//
//  HomeViewController.h
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeViewControllerProtocol <NSObject>

@optional
- (void)updateTitle:(NSString *)title;
- (void)fetchData;
@end


@interface HomeViewController : UIViewController<HomeViewControllerProtocol>

@end
