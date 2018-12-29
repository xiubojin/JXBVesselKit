//
//  ContactViewController.m
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign, getter=isEditing) BOOL editing;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"布局驱动UI";
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat headerViewY = 64;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, headerViewY, width, 50)];
    headerView.backgroundColor = [UIColor blueColor];
    self.headerView = headerView;
    [self.view addSubview:headerView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50+headerViewY, width, height-50-headerViewY) style:0];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 50;
    [self.view addSubview:tableView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:0 target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:0 target:self action:@selector(leftItemClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)rightItemClick {
    self.editing = !self.isEditing;
    [self.view setNeedsLayout];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)leftItemClick {
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    CGFloat headerViewHeight = 50.0f;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (self.isEditing) {
        //编辑状态
        CGFloat editCollectionViewHeight = 80;
        headerViewHeight = headerViewHeight + editCollectionViewHeight;
        self.headerView.frame = CGRectMake(0, 64, width, headerViewHeight);
        self.tableView.frame = CGRectMake(0, 64+headerViewHeight, width, height-64-headerViewHeight);
    }else{
        //非编辑状态
        self.headerView.frame = CGRectMake(0, 64, width, headerViewHeight);
        self.tableView.frame = CGRectMake(0, 50+64, width, height-50-64);
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"testcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = @"123456";
    return cell;
}

- (void)changeTitle:(NSString *)title {
    self.title = title;
}

@end
