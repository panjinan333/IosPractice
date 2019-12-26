//
//  LocalMusicViewController.m
//  IosPractice
//
//  Created by ltl on 2019/10/21.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "LocalMusicViewController.h"
#import "LocalMusicView.h"
#import "AudioPlayTabbarView.h"
#import "LocalMusicModel.h"
#import "AVPlayerQueueViewController.h"
#import "Constants.h"

@interface LocalMusicViewController ()<AudioPlayTabbarViewDelegate>

@property(nonatomic, strong) UIImageView * backgroundImg;
@property(nonatomic, strong) LocalMusicView * localMusicView;
@property(nonatomic, strong) AudioPlayTabbarView * tabView;
@property(nonatomic, strong) LocalMusicModel * audioModel;

@end

@implementation LocalMusicViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"本地音乐";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * backgroundImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backgroundImg.alpha = 0.8;
    backgroundImg.contentMode = UIViewContentModeScaleToFill;
    backgroundImg.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"globalBackgroundImg"]];
    self.backgroundImg = backgroundImg;
    [self.view addSubview:backgroundImg];
    
    float top = UPPEROFFSET;
    float scr = SCREENHEIGHT-34;
    float tab = AUDIOPLAYTABBARHEI;
    float main = scr - top - tab;
    LocalMusicView * localMusicView = [[LocalMusicView alloc] initWithFrame:CGRectMake(0, UPPEROFFSET, SCREENWIDTH, main)];
    localMusicView.backgroundColor = [UIColor clearColor];
    //    localMusicView.delegate = self;
    self.localMusicView = localMusicView;
    [self.view addSubview:localMusicView];
    
    CGFloat offsetY = scr - tab;
    AudioPlayTabbarView * tabView = [[AudioPlayTabbarView alloc] initWithFrame:CGRectMake(0, offsetY, SCREENWIDTH, AUDIOPLAYTABBARHEI)];
    tabView.delegate = self;
    [tabView.songListBtn addTarget:self action:@selector(showPlayingList) forControlEvents:UIControlEventTouchUpInside];
    self.tabView = tabView;
    [self.view addSubview:tabView];
    
    //本地音乐数据通知(通知的发送若比注册通知早，就会失效)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localSongDataFunction) name:@"localSongDataNotification" object:nil];
    //更新歌曲信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMainViewFunction) name:@"changeMainViewNSNotification" object:nil];
    
    LocalMusicModel * audioModel = [[LocalMusicModel alloc] init];
    self.audioModel = audioModel;
    [self.audioModel getLocalMusic];
}

- (void)dealloc{
    NSLog(@"456456");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeMainViewFunction{
    [self.tabView refreshUI];
}

- (void)showPlayingList{
    AVPlayerQueueViewController * playingList = [[AVPlayerQueueViewController alloc] init];
    playingList.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    playingList.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:playingList animated:YES completion:nil];
}

- (void)localSongDataFunction{
    NSLog(@"fsdfhfsdhfdshff");
    self.localMusicView.songListArray = self.audioModel.localSongListArray.mutableCopy;
    [self.localMusicView.songListTable reloadData];
}

@end
