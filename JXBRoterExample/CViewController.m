//
//  CViewController.m
//  JXBRoterExample
//
//  Created by 金修博 on 2017/7/24.
//  Copyright © 2017年 huber. All rights reserved.
//

#import "CViewController.h"

@interface CViewController ()

@property(nonatomic,assign) NSInteger count;
@property(nonatomic,copy) NSString *str;

@end

@implementation CViewController

+ (instancetype)createViewController:(id)parameters {
    CViewController *cVC = [[CViewController alloc] init];
    cVC.count = [[parameters valueForKey:@"count"] integerValue];
    cVC.str = [parameters valueForKey:@"str"];
    return cVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
    [btn setTitle:@"popB并修改label字符串" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"已经修改了" forKey:@"editStr"];
    self.handlerBlock(@"update", param);
    [self.navigationController popViewControllerAnimated:YES];
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
