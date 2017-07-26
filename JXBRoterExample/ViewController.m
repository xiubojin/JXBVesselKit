//
//  ViewController.m
//  JXBRoterExample
//
//  Created by 金修博 on 2017/7/24.
//  Copyright © 2017年 huber. All rights reserved.
//

#import "ViewController.h"
#import "JXBRouter.h"
#import "DViewController.h"

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
    [JXBRouter startRoute:@"demo://Bmodule/mall/list"];
}

- (IBAction)testClick:(id)sender {
    DViewController *dVC = [[DViewController alloc] init];
    [self.navigationController pushViewController:dVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
