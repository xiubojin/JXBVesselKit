//
//  ViewController.m
//  JXBRoterExample
//
//  Created by 金修博 on 2017/7/24.
//  Copyright © 2017年 huber. All rights reserved.
//

#import "ViewController.h"
#import "JXBRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)pushBClick:(UIButton *)sender {
    [JXBRouter registerRoutePattern:@"demo://Amodule/mall/detail" targetControllerName:@"BViewController"];
    [JXBRouter startRoute:@"demo://Amodule/mall/detail?info1=RouterDemo&info2=测试跳转&info3=123456789"];
}

- (IBAction)pushCClick:(id)sender {
    [JXBRouter registerRoutePattern:@"demo://Bmodule/mall/list" targetControllerName:@"DViewController" handler:^(NSString *handlerTag, id parameters) {
        NSLog(@"pushC button click");
    }];
    [JXBRouter startRoute:@"demo://Bmodule/mall/list?type=3c"];
//    NSURL *URL = [NSURL URLWithString:@"demo://Bmodule/mall/list?type=3c"];
//    [[UIApplication sharedApplication] openURL:URL options:nil completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
