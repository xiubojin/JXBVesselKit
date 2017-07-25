//
//  BViewController.m
//  JXBRoterExample
//
//  Created by 金修博 on 2017/7/24.
//  Copyright © 2017年 huber. All rights reserved.
//

#import "BViewController.h"

@interface BViewController ()
@property(nonatomic,strong) UILabel *lbl;
@end

@implementation BViewController

+ (instancetype)createViewController:(id)parameters {
    BViewController *bVC = [[BViewController alloc] init];
    return bVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 100)];
    lbl.textColor = [UIColor blackColor];
    lbl.font = [UIFont systemFontOfSize:17.0];
    lbl.text = @"当前是B控制器";
    self.lbl = lbl;
    [self.view addSubview:lbl];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
    [btn setTitle:@"pushC" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick {
    [JXBRouter registerRoutePattern:@"demo://Amodule/product/list" targetControllerName:@"CViewController" handler:^(NSString *handlerTag, id parameters) {
        if ([handlerTag isEqualToString:@"update"]) {
            self.lbl.text = [parameters valueForKey:@"editStr"];
            self.lbl.textColor = [UIColor redColor];
        }
    }];
    
    [JXBRouter startRoute:@"demo://Amodule/product/list?type=1234"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
