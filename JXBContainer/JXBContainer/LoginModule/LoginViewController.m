
//
//  LoginViewController.m
//  JXBContainer
//
//  Created by 金修博 on 2018/12/1.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginManager.h"

@interface LoginViewController ()
@property(nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) UITextField *usernameTF;
@property(nonatomic, strong) UITextField *passportTF;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.usernameTF = [[UITextField alloc] init];
    self.usernameTF.placeholder = @"请输入账号（登录后看控制台日志）";
    self.usernameTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.usernameTF];
    
    self.passportTF = [[UITextField alloc] init];
    self.passportTF.placeholder = @"请输入密码（登录后看控制台日志）";
    self.passportTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.passportTF];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.loginBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat w = 300;
    CGFloat x = (screenWidth - w) * 0.5;
    self.usernameTF.frame = CGRectMake(x, 100, w, 50);
    self.passportTF.frame = CGRectMake(x, 200, w, 50);
    self.loginBtn.frame = CGRectMake(0, 0, 200, 50);
    self.loginBtn.center = self.view.center;
}

- (void)loginBtnClick {
    NSString *username = self.usernameTF.text.length > 0 ? self.usernameTF.text : @"default_username";
    NSString *passport = self.passportTF.text.length > 0 ? self.passportTF.text : @"default_passport";
    [LoginManager loginSuccess:@{@"username":username, @"passport":passport}];
}

- (void)dealloc {
    NSLog(@"LoginViewController dealloc");
}


@end
