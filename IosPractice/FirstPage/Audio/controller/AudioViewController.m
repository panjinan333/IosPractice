//
//  AudioViewController.m
//  IosPractice
//
//  Created by ltl on 2019/10/8.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "AudioViewController.h"
#import "AudioView.h"
#import "AudioPlayTabbarView.h"
#import "AudioSetUpViewController.h"
#import "AudioPlayingViewController.h"
#import "LocalMusicViewController.h"
#import "AVPlayerQueueViewController.h"

#import "Constants.h"
#import "AVPlayerManager.h"
#import "AVPlayerQueueManager.h"
#import "DYLeftSlipManager.h"

@interface AudioViewController ()<AudioPlayTabbarViewDelegate,AudioViewDelegate>{
    int backgroundIndex;
    NSArray * backgroundArray;
}

@property(nonatomic, strong) UIImageView * backgroundImg;
@property(nonatomic, strong) AudioPlayTabbarView * tabView;

@end

@implementation AudioViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [[AVPlayerManager sharedManager] playSongWithItem:[[AVPlayerQueueManager sharedManager] currentPlayingMusic]];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    //设置导航栏背景图片为一个空的image
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = YES;
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],
//                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];

    //右侧按钮
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(mySetUp)];
    right.image = [UIImage imageNamed:@"page1_1.png"];
    self.navigationItem.rightBarButtonItem = right;
    
    //背景图片
    backgroundIndex = 1;
    backgroundArray = @[@"backgroundImg1.jpg",@"backgroundImg2.jpg",@"backgroundImg3.jpg",@"backgroundImg4.jpg",@"backgroundImg5.jpg"];
    UIImageView * backgroundImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backgroundImg.alpha = 0.8;
    backgroundImg.contentMode = UIViewContentModeScaleToFill;
    backgroundImg.image = [UIImage imageNamed:@"backgroundImg2.jpg"];
    self.backgroundImg = backgroundImg;
    [self.view addSubview:backgroundImg];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"backgroundImg2.jpg" forKey:@"globalBackgroundImg"];
//    [self.view insertSubview:backgroundImg atIndex:0];

    float top = UPPEROFFSET;
    float scr = SCREENHEIGHT-34;
    float tab = AUDIOPLAYTABBARHEI;
    float main = scr - top - tab;
    AudioView * audioView = [[AudioView alloc] initWithFrame:CGRectMake(0, UPPEROFFSET, SCREENWIDTH, main)];
    audioView.backgroundColor = [UIColor clearColor];
    audioView.delegate = self;
    [self.view addSubview:audioView];
    
    CGFloat offsetY = scr - tab;
    AudioPlayTabbarView * tabView = [[AudioPlayTabbarView alloc] initWithFrame:CGRectMake(0, offsetY, SCREENWIDTH, AUDIOPLAYTABBARHEI)];
    tabView.delegate = self;
    [tabView.songListBtn addTarget:self action:@selector(showPlayingList) forControlEvents:UIControlEventTouchUpInside];
    self.tabView = tabView;
    [self.view addSubview:tabView];
    
    //更新歌曲信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMainViewFunction) name:@"changeMainViewNSNotification" object:nil];
    //更新歌曲状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMainStateFunction) name:@"changeMainStateNSNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 自定义

- (void)mySetUp{
    //更换背景图片
    backgroundIndex++;
    if(backgroundIndex >= backgroundArray.count){
        backgroundIndex = 0;
    }
    NSString * name = [backgroundArray objectAtIndex:backgroundIndex];
    self.backgroundImg.image = [UIImage imageNamed:name];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:@"globalBackgroundImg"];
    NSLog(@"---%@",[defaults objectForKey:@"globalBackgroundImg"]);
    
//    [[DYLeftSlipManager sharedManager] showLeftView];
    /*
    AudioSetUpViewController * setUpVC = [[AudioSetUpViewController alloc] init];
    setUpVC.view.backgroundColor = [UIColor orangeColor];
    setUpVC.view.alpha = 1;
    //弹出时的动画风格（UIModalTransitionStyle属性）
    //底部划入
    setUpVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //水平翻转
//    setUpVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //交叉溶解
//    setUpVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //翻页
//    setUpVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;


    setUpVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController: setUpVC animated:YES completion:nil];
    */
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showPlayingList{
    AVPlayerQueueViewController * playingList = [[AVPlayerQueueViewController alloc] init];
    playingList.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    playingList.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:playingList animated:YES completion:nil];
}

#pragma mark - 通知

- (void)changeMainViewFunction{
    [self.tabView refreshUI];
}

- (void)changeMainStateFunction{
    [self.tabView refreshAVPlayerStatus];
}

#pragma mark - AudioPlayTabbarViewDelegate

- (void)pushSongDetailVC{
    AudioPlayingViewController * playing = [[AudioPlayingViewController alloc] init];    
    playing.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    playing.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:playing animated:YES completion:nil];
}

#pragma mark - AudioViewDelegate

- (void)pushLocalMusicVC{
    LocalMusicViewController * localMusic = [[LocalMusicViewController alloc] init];
    [self.navigationController pushViewController:localMusic animated:YES];
}

@end
