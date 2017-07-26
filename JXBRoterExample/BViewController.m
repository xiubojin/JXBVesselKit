//
//  BViewController.m
//  JXBRoterExample
//
//  Created by 金修博 on 2017/7/24.
//  Copyright © 2017年 huber. All rights reserved.
//

#import "BViewController.h"

@interface BViewController ()
@property(nonatomic,strong) UILabel *lbl1;
@property(nonatomic,strong) UILabel *lbl2;
@property(nonatomic,strong) UILabel *lbl3;
@property(nonatomic,copy) NSString *info1;
@property(nonatomic,copy) NSString *info2;
@property(nonatomic,copy) NSString *info3;
@end

@implementation BViewController

+ (instancetype)createViewController:(id)parameters {
    BViewController *bVC = [[BViewController alloc] init];
    bVC.title = [parameters valueForKey:@"title"];
    bVC.info1 = [parameters valueForKey:@"info1"];
    bVC.info2 = [parameters valueForKey:@"info2"];
    bVC.info3 = [parameters valueForKey:@"info3"];
    return bVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    self.title = @"B控制器";
    
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 300, 100)];
    lbl1.textColor = [UIColor blackColor];
    lbl1.font = [UIFont systemFontOfSize:17.0];
    lbl1.text = [NSString stringWithFormat:@"info1:%@",self.info1];
    self.lbl1 = lbl1;
    [self.view addSubview:lbl1];
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 300, 100)];
    lbl2.textColor = [UIColor blackColor];
    lbl2.font = [UIFont systemFontOfSize:17.0];
    lbl2.text = [NSString stringWithFormat:@"info2:%@",self.info2];
    self.lbl2 = lbl2;
    [self.view addSubview:lbl2];
    
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, 300, 100)];
    lbl3.textColor = [UIColor blackColor];
    lbl3.font = [UIFont systemFontOfSize:17.0];
    lbl3.text = [NSString stringWithFormat:@"info3:%@",self.info3];
    self.lbl3 = lbl3;
    [self.view addSubview:lbl3];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 250, 300, 50)];
    [btn1 setTitle:@"事件1-附带handler" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn1.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btn1 addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 300, 50)];
    [btn2 setTitle:@"事件2-覆盖handler" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn2.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btn2 addTarget:self action:@selector(btnClick2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)btnClick1 {
    [JXBRouter registerRoutePattern:@"demo://Amodule/product/list" targetControllerName:@"CViewController" handler:^(NSString *handlerTag, id parameters) {
        if ([handlerTag isEqualToString:@"update"]) {
            self.lbl1.text = [parameters valueForKey:@"editStr1"];
            self.lbl2.text = [parameters valueForKey:@"editStr2"];
            self.lbl3.text = [parameters valueForKey:@"editStr3"];
            self.lbl1.textColor = [UIColor redColor];
            self.lbl2.textColor = [UIColor redColor];
            self.lbl3.textColor = [UIColor redColor];
        }
    }];
    
    [JXBRouter startRoute:@"demo://Amodule/product/list?title=C控制器"];
}

- (void)btnClick2 {
    [JXBRouter registerRoutePattern:@"demo://Amodule/product/list" targetControllerName:@"CViewController" handler:^(NSString *handlerTag, id parameters) {
        self.lbl1.text = self.info1;
        self.lbl2.text = self.info2;
        self.lbl3.text = self.info3;
        self.lbl1.textColor = [UIColor blackColor];
        self.lbl2.textColor = [UIColor blackColor];
        self.lbl3.textColor = [UIColor blackColor];
    }];
    
    [JXBRouter startRoute:@"demo://Amodule/product/list?title=C控制器"];
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
