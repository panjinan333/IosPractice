//
//  AudioPlayingView.h
//  IosPractice
//
//  Created by ltl on 2019/10/11.
//  Copyright © 2019 Yin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioPlayingViewDelegate <NSObject>

/**
 * @brief 推出歌曲详情页
 */
//- (void)pushSongDetailVC;

@end

@interface AudioPlayingView : UIView

//title
@property(nonatomic, strong) UIButton * backBtn;
@property(nonatomic, strong) UIButton * shareBtn;
@property(nonatomic, strong) UILabel * songName;
@property(nonatomic, strong) UILabel * singerName;
//center
@property(nonatomic, strong) UIView * mainView;
@property(nonatomic, strong) UIImageView * centerImg;
//bottom
@property(nonatomic, strong) UIView * bottomView;
@property(nonatomic, strong) UISlider * progressSlider;
@property(nonatomic, strong) UILabel * currentTime;
@property(nonatomic, strong) UILabel * stopTime;
@property(nonatomic, strong) UIButton * playModelBtn;
@property(nonatomic, strong) UIButton * previousBtn;
@property(nonatomic, strong) UIButton * playSongBtn;
@property(nonatomic, strong) UIButton * pauseSongBtn;
@property(nonatomic, strong) UIButton * nextBtn;
@property(nonatomic, strong) UIButton * songListBtn;

@property(nonatomic, strong) NSTimer * progresstimer;
@property(nonatomic, strong) NSTimer * lrctimer;

@property(nonatomic, assign) BOOL isDragging;

- (void)getCurrentSongInfo;
- (void)getCurrentSongStatus;

@property(nonatomic, weak)   id<AudioPlayingViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
