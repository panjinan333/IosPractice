//
//  AudioPlayingViewController.m
//  IosPractice
//
//  Created by ltl on 2019/10/11.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "AudioPlayingViewController.h"
#import "AudioPlayingView.h"
#import "Constants.h"
#import "AVPlayerQueueManager.h"
#import "AVPlayerQueueViewController.h"

@interface AudioPlayingViewController ()

@property (nonatomic, strong) AudioPlayingView * audioPlayView;
@property (nonatomic, strong) UIImageView * backgroundImg;
@end

@implementation AudioPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    float top = STATUSHEIFHT;
    float scr = SCREENHEIGHT-34;
    AudioPlayingView * audioPlayView = [[AudioPlayingView alloc] initWithFrame:CGRectMake(0, top, SCREENWIDTH, scr - top)];
    [audioPlayView.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [audioPlayView.songListBtn addTarget:self action:@selector(showPlayingList) forControlEvents:UIControlEventTouchUpInside];
    self.audioPlayView = audioPlayView;
    [self.view addSubview:audioPlayView];
    
    //更新歌曲信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMusicViewFunction) name:@"changeMusicViewNSNotification" object:nil];
    //更新歌曲状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMusicStateFunction) name:@"changeMusicStateNSNotification" object:nil];
}

- (void)initUI{
    UIImageView * backgroundImg = [[UIImageView alloc] init];
    backgroundImg.image = [UIImage imageNamed:[[AVPlayerQueueManager sharedManager] currentPlayingMusic].song_image];
    backgroundImg.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    self.backgroundImg = backgroundImg;
    [self.view addSubview:backgroundImg];
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view addSubview:effectView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.audioPlayView.progresstimer invalidate];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:^{
        self.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    }];
}

- (void)showPlayingList{
    AVPlayerQueueViewController * playingList = [[AVPlayerQueueViewController alloc] init];
    playingList.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    playingList.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:playingList animated:YES completion:nil];
}

#pragma mark - 通知

- (void)changeMusicViewFunction{
    //当前曲子播放完毕，获取下一曲，并刷新视图
    NSLog(@"更新视图");
    [self.audioPlayView getCurrentSongInfo];
    self.backgroundImg.image = [UIImage imageNamed:[[AVPlayerQueueManager sharedManager] currentPlayingMusic].song_image];
}

- (void)changeMusicStateFunction{
    NSLog(@"更新状态");
    [self.audioPlayView getCurrentSongStatus];
}

@end
