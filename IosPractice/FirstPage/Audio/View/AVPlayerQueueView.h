//
//  AVPlayerQueueView.h
//  IosPractice
//
//  Created by ltl on 2019/10/21.
//  Copyright © 2019 Yin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AVPlayerQueueViewDelegate <NSObject>

/**
 * @brief 隐藏
 */
- (void)hideMusicListVC;

@end

@interface AVPlayerQueueView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIView * header;
@property(nonatomic, strong) UIImageView * modelImg;
@property(nonatomic, strong) UILabel * playModel;
@property(nonatomic, strong) UIImageView * deleteAll;
@property(nonatomic, strong) UILabel * line;
@property(nonatomic, strong) UITableView * palyerQueueTable;
@property(nonatomic, strong) NSMutableArray * palyerQueueArray;

@property(nonatomic, weak)   id<AVPlayerQueueViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
