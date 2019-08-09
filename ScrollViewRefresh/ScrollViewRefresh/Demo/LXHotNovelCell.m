//
//  LXHotNovelCell.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/9.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXHotNovelCell.h"
#import "LXNonPageSingleController.h"

@interface LXHotNovelCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *bookIntroLbl;

@end

@implementation LXHotNovelCell

- (void)setHotModel:(LXHotNovelModel *)hotModel {
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:hotModel.book_cover]];
    self.bookNameLbl.text = hotModel.bookname;
    self.authorNameLbl.text = hotModel.author_name;
    self.bookIntroLbl.text = hotModel.introduction;
}

@end
