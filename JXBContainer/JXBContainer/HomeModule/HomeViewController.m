//
//  HomeViewController.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "HomeViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "JXBContainerDefines.h"
#import "LoginManager.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, copy) NSArray *dataSource;
@property(nonatomic, copy) NSArray *selectorSource;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[@"本地推送测试",
                        @"触发自定义事件",
                        @"修改所有一级页面title",
                        @"测试TA-completion",
                        @"退出"];
    
    self.selectorSource = @[@"localpush",
                            @"triggerCustomEvent",
                            @"editTitle",
                            @"live",
                            @"logout"];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height) style:0];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 50;
    [self.view addSubview:tableView];
}

#pragma mark - HomeViewControllerProtocol
- (void)updateTitle:(NSString *)title {
    self.title = title;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"testcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectorStr = self.selectorSource[indexPath.row];
    SEL selector = NSSelectorFromString(selectorStr);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector];
#pragma clang diagnostic pop
}

#pragma mark - cell click
- (void)localpush {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = @"本地推送测试";
            content.body = @"jxb://CRM1/detail?id=123456789#push";
            content.categoryIdentifier = NSStringFromSelector(_cmd);
            content.sound = [UNNotificationSound defaultSound];
            
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
            UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:trigger];
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    NSLog(@"已成功加推送%@",notificationRequest.identifier);
                }
            }];
        }
    }];
}

- (void)triggerCustomEvent {
    [[JXBModuleManager shareInstance] triggerEvent:@"mod58PushMessageEvent:" customParam:@{@"message":@"这是一条推送CRM推送消息."}];
}

- (void)editTitle {
    [[JXBModuleManager shareInstance] triggerEvent:kModCustomEvent customParam:@{@"title":@"JXBContainer"}];
}

- (void)live {
    [JXBRouter openURL:[NSURL URLWithString:@"jxb://CRM/detail?id=123456789#push"]];
}

- (void)logout {
    [LoginManager logoutSuccess];
}


@end
