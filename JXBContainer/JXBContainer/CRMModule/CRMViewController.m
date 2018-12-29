//
//  CRMViewController.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "CRMViewController.h"

@interface CRMViewController ()
@property(nonatomic, strong) UILabel *lbl;
@end

@implementation CRMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CRM";
    self.view.backgroundColor = [UIColor brownColor];
    
    self.lbl = [[UILabel alloc] init];
    self.lbl.text = self.message;
    self.lbl.font = [UIFont systemFontOfSize:17.0];
    self.lbl.textColor = [UIColor blackColor];
    [self.lbl sizeToFit];
    [self.view addSubview:self.lbl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.lbl.center = self.view.center;
}

- (void)dealloc {
    NSLog(@"CRMViewController dealloc");
}


@end
