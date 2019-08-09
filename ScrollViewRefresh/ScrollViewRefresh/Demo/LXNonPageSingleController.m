//
//  LXNonPageSingleController.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/9.
//  Copyright © 2019 starxin. All rights reserved.
//
#import "LXNonPageSingleController.h"

@implementation LXHotNovelModel


@end

@interface LXNonPageSingleController ()<LXNetworkConfigureProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *novelIconImgV;
@property (weak, nonatomic) IBOutlet UILabel *novelNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *novelAuthorLbl;
@property (weak, nonatomic) IBOutlet UILabel *novelInfoLbl;
@property (weak, nonatomic) IBOutlet UILabel *novelIntroLbl;

@property (nonatomic, strong) LXHotNovelModel* hotNovelModel;

@end

@implementation LXNonPageSingleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.view.lx_delegate = self;
    [self.view lx_requestData];
}
- (void)p_actionForUpdateNovelContent {
    [self.novelIconImgV sd_setImageWithURL:[NSURL URLWithString:self.hotNovelModel.book_cover]];
    self.novelNameLbl.text = self.hotNovelModel.bookname;
    self.novelAuthorLbl.text = self.hotNovelModel.author_name;
    self.novelInfoLbl.text = self.hotNovelModel.book_info;
    self.novelIntroLbl.text = self.hotNovelModel.introduction;
}

#pragma mark --- LXNetworkConfigureProtocol
- (nonnull NSString*)lx_url {
    return @"https://www.apiopen.top/novelApi";
}
- (nullable Class)lx_dataClass {
    return LXHotNovelModel.class;
}
- (void)lx_failRequestWithMessage:(nullable NSString*)msg code:(NSInteger)code url:(nonnull NSString*)url {
    NSLog(@"fail request: url=%@,code=%zd,msg=%@", url,code,msg);
}
- (void)lx_cancelTaskWithUrl:(nonnull NSString*)url {
    NSLog(@"cancel task: url=%@", url);
}
- (void)lx_successRequestData:(nullable id)responseData url:(nonnull NSString*)url {
    NSLog(@"success request: url=%@,data=%@",url,responseData);
    self.hotNovelModel = [responseData firstObject];
    [self p_actionForUpdateNovelContent];
}

@end

