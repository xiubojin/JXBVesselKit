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
    cVC.title = [parameters valueForKey:@"title"];
    return cVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
    [btn1 setTitle:@"验证事件1" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn1.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btn1 addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 200, 50)];
    [btn2 setTitle:@"验证事件2" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn2.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btn2 addTarget:self action:@selector(btnClick2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)btnClick1 {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"RouterDemo+editStr1" forKey:@"editStr1"];
    [param setValue:@"测试跳转+editStr2" forKey:@"editStr2"];
    [param setValue:@"123456789+editStr3" forKey:@"editStr3"];
    self.handlerBlock(@"update", param);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClick2 {
    self.handlerBlock(nil, nil);
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
