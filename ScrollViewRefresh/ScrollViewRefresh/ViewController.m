//
//  ViewController.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/7/23.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "ViewController.h"
#import "Library/UIView+LXNetwork.h"
#import "LXNewsModel.h"
#import "LXScrollView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,LXNetworkConfigureProtocol>

@property (nonatomic, strong) LXScrollView* tableView;
@property (nonatomic, strong) LXNewsModel* newsModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableView = [[LXScrollView alloc] initWithFrame:CGRectMake(20, 200, 300, 300) style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:self.tableView];
    self.tableView.lx_delegate = self;
    [self.tableView lx_requestData];
}
#pragma mark --- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsModel.autoArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"index---%tu", indexPath.row];
    cell.textLabel.textColor = UIColor.darkGrayColor;
    return cell;
}
#pragma mark --- LXNetworkConfigureProtocol
- (NSString*)lx_url {
    return @"https://www.apiopen.top/journalismApi";
}
- (LXMethodOption)lx_methodOption {
    return LXMethodOptionPost;
}
- (nullable Class)lx_dataClass {
    return LXNewsModel.class;
}
- (LXRefreshOption)lx_refreshOption {
    return LXRefreshOptionHeaderFooter;
}

- (void)lx_successRequestData:(nullable id)responseData url:(NSString*)url {
    NSLog(@"11111---%@", url);
    self.newsModel = responseData;
    [self.tableView reloadData];
}
- (void)lx_failRequestWithMessage:(nullable NSString*)msg code:(NSInteger)code url:(NSString*)url {
    NSLog(@"22222---%@---%tu---%@",msg,code,url);
}
- (void)lx_cancelTaskWithUrl:(nonnull NSString*)url {
//    NSLog(@"lx_cancelTaskWithUrl---%@",url);
}

@end
