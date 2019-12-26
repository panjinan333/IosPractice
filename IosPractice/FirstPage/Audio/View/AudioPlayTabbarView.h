//
//  AudioPlayTabbarView.h
//  IosPractice
//
//  Created by ltl on 2019/10/11.
//  Copyright © 2019 Yin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioPlayTabbarViewDelegate <NSObject>

/**
 * @brief 推出歌曲详情页
 */
- (void)pushSongDetailVC;

@end

@interface AudioPlayTabbarView : UIView

@property(nonatomic, strong) UIVisualEffectView * effectView;
@property(nonatomic, strong) UIImageView * songPhotoImg;
@property(nonatomic, strong) UIButton * playSongBtn;
@property(nonatomic, strong) UIButton * pauseSongBtn;
@property(nonatomic, strong) UIButton * songListBtn;
@property(nonatomic, strong) UILabel * songName;
@property(nonatomic, strong) UILabel * singerName;

@property(nonatomic, weak)   id<AudioPlayTabbarViewDelegate> delegate;

- (void)refreshUI;
- (void)refreshAVPlayerStatus;

@end

NS_ASSUME_NONNULL_END
