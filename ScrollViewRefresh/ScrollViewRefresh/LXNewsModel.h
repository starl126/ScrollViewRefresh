//
//  LXNewsModel.h
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/9.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXAutoNewsModel : NSObject

@property (nonatomic, copy) NSString* addata;
@property (nonatomic, copy) NSString* category;
@property (nonatomic, copy) NSString* channel;
@property (nonatomic, copy) NSString* digest;
@property (nonatomic, copy) NSString* link;
@property (nonatomic, copy) NSString* liveInfo;
@property (nonatomic, strong) NSArray* picInfo;
@property (nonatomic, copy) NSString* ptime;
@property (nonatomic, copy) NSString* source;
@property (nonatomic, assign) NSInteger tcount;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* unlikeReason;
@property (nonatomic, copy) NSString* videoInfo;

@end


@interface LXNewsModel : NSObject

@property (nonatomic, strong) NSArray<LXAutoNewsModel*>* autoArr;
@property (nonatomic, strong) NSArray<LXAutoNewsModel*>* dyArr;
@property (nonatomic, strong) NSArray<LXAutoNewsModel*>* entArr;
@property (nonatomic, strong) NSArray<LXAutoNewsModel*>* moneyArr;
@property (nonatomic, strong) NSArray<LXAutoNewsModel*>* sportsArr;
@property (nonatomic, strong) NSArray<LXAutoNewsModel*>* techArr;
@property (nonatomic, strong) NSArray<LXAutoNewsModel*>* toutiaoArr;
@property (nonatomic, strong) NSArray<LXAutoNewsModel*>* warArr;

@end

NS_ASSUME_NONNULL_END
