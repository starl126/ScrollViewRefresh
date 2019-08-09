//
//  LXNonPageSingleController.h
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/9.
//  Copyright © 2019 starxin. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN
@interface LXHotNovelModel : NSObject

@property (nonatomic, copy) NSString* author_name;
@property (nonatomic, copy) NSString* book_cover;
@property (nonatomic, copy) NSString* book_info;
@property (nonatomic, copy) NSString* bookname;
@property (nonatomic, copy) NSString* class_name;
@property (nonatomic, copy) NSString* introduction;
@property (nonatomic, copy) NSString* topic;
@property (nonatomic, copy) NSString* topic_first;

@end

///非分页单接口
@interface LXNonPageSingleController : UIViewController

@end

NS_ASSUME_NONNULL_END
