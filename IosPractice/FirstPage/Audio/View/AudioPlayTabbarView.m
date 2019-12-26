//
//  AudioPlayTabbarView.m
//  IosPractice
//
//  Created by ltl on 2019/10/11.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "AudioPlayTabbarView.h"
#import "Constants.h"
#import "AVPlayerManager.h"
#import "AVPlayerQueueManager.h"

@implementation AudioPlayTabbarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        /** 模糊效果的三种风格
        * UIBlurEffectStyleExtraLight,  //高亮
        * UIBlurEffectStyleLight,       //亮
        * UIBlurEffectStyleDark         //暗
        */
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.effectView = effectView;
        [self addSubview:effectView];
        
        UIImageView * songPhotoImg = [[UIImageView alloc] init];
        songPhotoImg.userInteractionEnabled = YES;
        songPhotoImg.layer.masksToBounds = YES;
        self.songPhotoImg  = songPhotoImg;
        [effectView.contentView addSubview:songPhotoImg];

        UIButton * playSongBtn = [[UIButton alloc] init];
        [playSongBtn setImage:[UIImage imageNamed:@"playSongImage.png"] forState:UIControlStateNormal];
        [playSongBtn addTarget:self action:@selector(playCurrentSong) forControlEvents:UIControlEventTouchUpInside];
        playSongBtn.hidden = YES;
        self.playSongBtn = playSongBtn;
        [effectView.contentView addSubview:playSongBtn];
        
        UIButton * pauseSongBtn = [[UIButton alloc] init];
        [pauseSongBtn setImage:[UIImage imageNamed:@"pauseSongImage.png"] forState:UIControlStateNormal];
        [pauseSongBtn addTarget:self action:@selector(pauseCurrentSong) forControlEvents:UIControlEventTouchUpInside];
        pauseSongBtn.hidden = YES;
        self.pauseSongBtn = pauseSongBtn;
        [effectView.contentView addSubview:pauseSongBtn];

        UIButton * songListBtn = [[UIButton alloc] init];
        [songListBtn setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        self.songListBtn = songListBtn;
        [effectView.contentView addSubview:songListBtn];
        
        UILabel * songName = [[UILabel alloc] init];
        songName.userInteractionEnabled = YES;
        songName.textColor = themeColor;
        self.songName = songName;
        [effectView.contentView addSubview:songName];
        
        UILabel * singerName = [[UILabel alloc] init];
        singerName.userInteractionEnabled = YES;
        singerName.textColor = themeColor;
        self.singerName = singerName;
        [effectView.contentView addSubview:singerName];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDetail)];
        [self.songPhotoImg addGestureRecognizer:tap];
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDetail)];
        [self.songName addGestureRecognizer:tap1];
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDetail)];
        [self.singerName addGestureRecognizer:tap2];
        
        [self refreshAVPlayerStatus];
        [self refreshUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.songPhotoImg.frame = CGRectMake(5, 5, self.effectView.frame.size.height - 10, self.effectView.frame.size.height - 10);
    self.songPhotoImg.layer.cornerRadius = self.songPhotoImg.frame.size.height/2;
    
    self.playSongBtn.frame = CGRectMake(self.effectView.frame.size.width - self.effectView.frame.size.height * 2 + 10, 10, self.effectView.frame.size.height - 20, self.effectView.frame.size.height - 20);
    self.pauseSongBtn.frame = CGRectMake(self.effectView.frame.size.width - self.effectView.frame.size.height * 2 + 10, 10, self.effectView.frame.size.height - 20, self.effectView.frame.size.height - 20);
    
    self.songListBtn.frame = CGRectMake(self.effectView.frame.size.width - self.effectView.frame.size.height + 10, 10, self.effectView.frame.size.height - 20, self.effectView.frame.size.height - 20);
    
    self.songName.frame = CGRectMake(self.effectView.frame.size.height + 5, 0, self.effectView.frame.size.width - self.effectView.frame.size.height * 3 - 5, self.effectView.frame.size.height / 2);
    self.singerName.frame = CGRectMake(self.effectView.frame.size.height + 5, self.effectView.frame.size.height / 2, self.effectView.frame.size.width - self.effectView.frame.size.height * 3 - 5, self.effectView.frame.size.height / 2);
}

- (void)refreshUI{
    self.songPhotoImg.image = [UIImage imageNamed:[[AVPlayerQueueManager sharedManager] currentPlayingMusic].song_image];
    self.songName.text = [[AVPlayerQueueManager sharedManager] currentPlayingMusic].song_name;
    self.singerName.text = [[AVPlayerQueueManager sharedManager] currentPlayingMusic].song_singer;
}

- (void)refreshAVPlayerStatus{
    float status = [AVPlayerManager sharedManager].player.rate;
    if( status != 0 ){
        NSLog(@"AudioPlayTabbarView：播放中");
        self.playSongBtn.hidden = YES;
        self.pauseSongBtn.hidden = NO;
    }
    else{
        NSLog(@"AudioPlayTabbarView：暂停中");
        self.playSongBtn.hidden = NO;
        self.pauseSongBtn.hidden = YES;
    }
}

- (void)pushDetail{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushSongDetailVC)]) {
        [self.delegate pushSongDetailVC];
    }
}

- (void)playCurrentSong{
    //播放功能
    //图标 变为 暂停
    self.playSongBtn.hidden = YES;
    self.pauseSongBtn.hidden = NO;
    [[AVPlayerManager sharedManager] palySongAtOneTime:[AVPlayerManager sharedManager].player.currentTime];
}

- (void)pauseCurrentSong{
    //暂停功能
    //图标 变为 播放
    self.playSongBtn.hidden = NO;
    self.pauseSongBtn.hidden = YES;
    [[AVPlayerManager sharedManager] pauseSong];
}

@end
