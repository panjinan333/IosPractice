//
//  AudioPlayingView.m
//  IosPractice
//
//  Created by ltl on 2019/10/11.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "AudioPlayingView.h"
#import "Constants.h"
#import "AVPlayerManager.h"
#import "AVPlayerQueueManager.h"
#import "AVPlayerModelObj.h"

@implementation AudioPlayingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self titleView];
        [self centerView];
        [self footView];
        
        [self getCurrentSongInfo];
        [self getCurrentSongStatus];
        self.isDragging = false;
    }
    return self;
}

- (void)titleView{
    UIButton * backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    self.backBtn = backBtn;
    [self addSubview:backBtn];
    
    UIButton * shareBtn = [[UIButton alloc] init];
    [shareBtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    self.shareBtn = shareBtn;
    [self addSubview:shareBtn];
    
    UILabel * songName = [[UILabel alloc] init];
    songName.text = @"";
    songName.textColor = themeColor;
    self.songName = songName;
    [self addSubview:songName];
    
    UILabel * singerName = [[UILabel alloc] init];
    singerName.text = @"";
    singerName.textColor = themeColor;
    self.singerName = singerName;
    [self addSubview:singerName];
}

- (void)centerView{
    UIView * mainView = [[UIView alloc] init];
    mainView.tag = 1001;
    self.mainView = mainView;
    [self addSubview:mainView];
    
    
    UIImageView * centerImg = [[UIImageView alloc] init];
//    centerImg.image = [UIImage imageNamed:@"icon4.png"];
    centerImg.userInteractionEnabled = NO;
    centerImg.layer.masksToBounds = YES;
//    centerImg.contentMode = UIViewContentModeScaleAspectFit;
    self.centerImg  = centerImg;
    
    [mainView addSubview:centerImg];
    
}

- (void)footView{
    UIView * bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    
    UISlider * progressSlider = [[UISlider alloc] init];
    progressSlider.minimumValue = 0;
    self.progressSlider = progressSlider;
    UIImage * originalSize = [UIImage imageNamed:@"icon5.png"];
    UIGraphicsBeginImageContext(CGSizeMake(15, 15));
    [originalSize drawInRect:CGRectMake(0, 0, 15, 15)];
    UIImage * scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 滑块颜色
//    progressSlider.thumbTintColor = [UIColor whiteColor];
    // 走过的进度条的颜色
    progressSlider.minimumTrackTintColor = orangeColor;
    [progressSlider setThumbImage:scaleImage forState:UIControlStateNormal];
    [progressSlider setThumbImage:scaleImage forState:UIControlStateHighlighted];
    [progressSlider addTarget:self action:@selector(UISliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [progressSlider addTarget:self action:@selector(UISliderTouchDown) forControlEvents:UIControlEventTouchDown];
    [progressSlider addTarget:self action:@selector(UISliderTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:progressSlider];
    
    UILabel * currentTime = [[UILabel alloc] init];
    currentTime.text = @"00:00";
    currentTime.textColor = themeColor;
    currentTime.font = [UIFont systemFontOfSize:13];
    currentTime.textAlignment = NSTextAlignmentCenter;
    self.currentTime = currentTime;
    [bottomView addSubview:currentTime];
    
    UILabel * stopTime = [[UILabel alloc] init];
    stopTime.text = @"00:00";
    stopTime.textColor = themeColor;
    stopTime.font = [UIFont systemFontOfSize:13];
    stopTime.textAlignment = NSTextAlignmentCenter;
    self.stopTime = stopTime;
    [bottomView addSubview:stopTime];
    
    UIButton * playModelBtn = [[UIButton alloc] init];
//    [playModelBtn setImage:[UIImage imageNamed:@"icon3.png"] forState:UIControlStateNormal];
    [playModelBtn addTarget:self action:@selector(changePlayingModel) forControlEvents:UIControlEventTouchUpInside];
    self.playModelBtn = playModelBtn;
    [bottomView addSubview:playModelBtn];
    
    UIButton * previousBtn = [[UIButton alloc] init];
    [previousBtn setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [previousBtn addTarget:self action:@selector(previousSong) forControlEvents:UIControlEventTouchUpInside];
    self.previousBtn = previousBtn;
    [bottomView addSubview:previousBtn];
    
    UIButton * playSongBtn = [[UIButton alloc] init];
    [playSongBtn setImage:[UIImage imageNamed:@"playSongImage.png"] forState:UIControlStateNormal];
    [playSongBtn addTarget:self action:@selector(playCurrentSong) forControlEvents:UIControlEventTouchUpInside];
    playSongBtn.hidden = YES;
    self.playSongBtn = playSongBtn;
    [bottomView addSubview:playSongBtn];
    
    UIButton * pauseSongBtn = [[UIButton alloc] init];
    [pauseSongBtn setImage:[UIImage imageNamed:@"pauseSongImage.png"] forState:UIControlStateNormal];
    [pauseSongBtn addTarget:self action:@selector(pauseCurrentSong) forControlEvents:UIControlEventTouchUpInside];
    pauseSongBtn.hidden = YES;
    self.pauseSongBtn = pauseSongBtn;
    [bottomView addSubview:pauseSongBtn];
    
    UIButton * nextBtn = [[UIButton alloc] init];
    [nextBtn setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextSong) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextBtn;
    [bottomView addSubview:nextBtn];
    
    UIButton * songListBtn = [[UIButton alloc] init];
    [songListBtn setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    self.songListBtn = songListBtn;
    [bottomView addSubview:songListBtn];
    
    self.progresstimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatePerSecond) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //title
    CGFloat width = self.frame.size.width;
    float height = 60;
    self.backBtn.frame = CGRectMake(0.15*height, 0.2*height, 0.6*height, 0.6*height);
    self.shareBtn.frame = CGRectMake(width-height+0.25*height, 0.25*height, 0.5*height, 0.5*height);
    self.songName.frame = CGRectMake(height, 0, width-height*2, height/2);
    self.singerName.frame = CGRectMake(height, height/2, width-height*2, height/2);
    
    //center
    CGFloat bottomHei = 130;
    self.mainView.frame = CGRectMake(0, height, width, self.frame.size.height-height-bottomHei);
    self.centerImg.frame = CGRectMake(width*0.2, (self.mainView.frame.size.height-60-width*0.6)/2, width*0.6, width*0.6);
    self.centerImg.layer.cornerRadius = self.centerImg.frame.size.height/2;
    
    CALayer * layer = [CALayer layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.borderWidth = 3;
    layer.opacity = 0.7;
    layer.borderColor = orangeColor.CGColor;
    layer.frame = self.centerImg.frame;
    layer.cornerRadius = self.centerImg.frame.size.width/2;
    [self.mainView.layer addSublayer:layer];
    
    //bottom
    CGFloat singleWidth = width/5;
    self.bottomView.frame = CGRectMake(0, self.mainView.frame.origin.y + self.mainView.frame.size.height, width, bottomHei);
    
    CGFloat inner = 40;
    CGFloat labelWidth = 60;
    self.currentTime.frame = CGRectMake(0, 0, labelWidth, inner);
    self.stopTime.frame = CGRectMake(width-1*labelWidth, 0, labelWidth, inner);
    self.progressSlider.frame = CGRectMake(labelWidth, 0, width-2*labelWidth, inner);
    
    self.playModelBtn.frame = CGRectMake(singleWidth*(0+0.3), inner+singleWidth*0.3, singleWidth*0.4, singleWidth*0.4);
    self.previousBtn.frame = CGRectMake(singleWidth*(1+0.3), inner+singleWidth*0.3, singleWidth*0.4, singleWidth*0.4);
    self.playSongBtn.frame = CGRectMake(singleWidth*(2+0.1), inner+singleWidth*0.1, singleWidth*0.8, singleWidth*0.8);
    self.pauseSongBtn.frame = CGRectMake(singleWidth*(2+0.1), inner+singleWidth*0.1, singleWidth*0.8, singleWidth*0.8);
    self.nextBtn.frame = CGRectMake(singleWidth*(3+0.3), inner+singleWidth*0.3, singleWidth*0.4, singleWidth*0.4);
    self.songListBtn.frame = CGRectMake(singleWidth*(4+0.3), inner+singleWidth*0.3, singleWidth*0.4, singleWidth*0.4);
    
    //视频层
//    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
//    playerLayer.frame = CGRectMake(0, 500, 375, 100);
//    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//    avPlayer.volume = 3.0f;
//    [self.view.layer addSublayer:self.playerLayer];
}

#pragma mark - uislider 事件

- (void)UISliderValueChanged{
    //拖拽过程中停止进度条定时器
//    NSLog(@"拖拽进度：%f",self.progressSlider.value);
    
    //滑动过程中更新页面上的时间显示
 
    CMTime totalTime = [AVPlayerManager sharedManager].playerItem.asset.duration;
    Float64 time = CMTimeGetSeconds(totalTime);
    int minute = (int)(time * self.progressSlider.value + 1) / 60;
    int second = (int)(time * self.progressSlider.value +  1) % 60;
    self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d",minute,second];

}

- (void)UISliderTouchDown{
    NSLog(@"按钮 下");
    self.isDragging = true;
    //关闭定时
    [self.progresstimer setFireDate:[NSDate distantFuture]];
}

- (void)UISliderTouchUpInside{
    NSLog(@"按钮 起");//调进度
    
//    typedef struct
//    {
//        CMTimeValue    value;        /*! @field value The value of the CMTime. value/timescale = seconds. */
//        CMTimeScale    timescale;    /*! @field timescale The timescale of the CMTime. value/timescale = seconds.  */
//        CMTimeFlags    flags;        /*! @field flags The flags, eg. kCMTimeFlags_Valid, kCMTimeFlags_PositiveInfinity, etc. */
//        CMTimeEpoch    epoch;        /*! @field epoch Differentiates between equal timestamps that are actually different because
//                                      of looping, multi-item sequencing, etc.
//                                      Will be used during comparison: greater epochs happen after lesser ones.
//                                      Additions/subtraction is only possible within a single epoch,
//                                      however, since epoch length may be unknown/variable. */
//    } CMTime;
    
    
    int timescale = [AVPlayerManager sharedManager].playerItem.currentTime.timescale;
    
    CMTime totalTime = [AVPlayerManager sharedManager].playerItem.asset.duration;
    Float64 time = CMTimeGetSeconds(totalTime);
    
    float point = self.progressSlider.value * timescale * time;
    
    NSLog(@"拖拽范围：%d",timescale);
    NSLog(@"拖拽范围：%f",point);
    NSLog(@"拖拽进度：%f",self.progressSlider.value);
    NSLog(@"拖拽总长：%f",time);
//    Float64 time = CMTimeGetSeconds(totalTime);
//    int minute = (int)(time * self.progressSlider.value + 1) / 60;
//    int second = (int)(time * self.progressSlider.value + 1) % 60;
//    CMTimeMakeWithSeconds(currentTime, self.playerItem.currentTime.timescale)
//    CMTimeMake(self.progressSlider.value, 1)
    // 时间不对
    [[AVPlayerManager sharedManager] palySongAtOneTime:CMTimeMake(point, timescale)];
    //开启定时
    [self.progresstimer setFireDate:[NSDate distantPast]];
}

#pragma mark - 执行事件

- (void)getCurrentSongInfo{
    //获取播放歌曲名称，歌手，背景图片，播放状态及进度，时长，播放模式
    self.songName.text = [[AVPlayerQueueManager sharedManager] currentPlayingMusic].song_name;
    self.singerName.text = [[AVPlayerQueueManager sharedManager] currentPlayingMusic].song_singer;
    self.centerImg.image = [UIImage imageNamed:[[AVPlayerQueueManager sharedManager] currentPlayingMusic].song_image];
    
    self.currentTime.text = [[AVPlayerManager sharedManager] currentTimeOfSong];
    self.stopTime.text = [[AVPlayerManager sharedManager] durationOfSong];
    
    self.progressSlider.value = [[AVPlayerManager sharedManager] currentProgressOfSong];
    //    self.progressSlider.maximumValue = [[[AVPlayerManager sharedManager] durationOfSong] floatValue];
    
    AVPlayerModelObj * model = [[AVPlayerQueueManager sharedManager] currentPlayingModel];
    [self.playModelBtn setImage:[UIImage imageNamed:model.model_image] forState:UIControlStateNormal];
}

- (void)getCurrentSongStatus{
    float status = [AVPlayerManager sharedManager].player.rate;
    NSLog(@"状态-%f",status);
    if( status != 0 ){
        //播放中
        NSLog(@"AudioPlayingView：播放中");
        self.playSongBtn.hidden = YES;
        self.pauseSongBtn.hidden = NO;
        
        [self startRotateAnimation:self.centerImg];
        //开启定时
        [self.progresstimer setFireDate:[NSDate distantPast]];
        [self startWaterRippleEffect:self.centerImg.frame];
        
    }
    
    else{
        NSLog(@"AudioPlayingView：暂停中");

        self.playSongBtn.hidden = NO;
        self.pauseSongBtn.hidden = YES;
        
        [self stopRotateAnimation:self.centerImg];
        //关闭定时
        [self.progresstimer setFireDate:[NSDate distantFuture]];
        [self stopWaterRippleEffect];
    }
    

//    通过CMTimeGetSeconds([_player currentTime]) / 60可以获得当前分钟,CMTimeGetSeconds([_player currentTime]) % 60可以获得当前秒数
//    通过playerItem.duration.value / _playerItem.duration.timescale / 60可以获得视频总分钟数,通过playerItem.duration.value / _playerItem.duration.timescale % 60可以获得视频总时间减分钟的秒数


    /*
    WeakSelf(weakSelf);
    //player的addPeriodicTimeObserverForInterval:CMTimeMake方法是监听播放进度 然后更新slider的value就可以实现播放时slider跟随播放时间滑动
    [[TYVoiceManager sharedInstance].player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (!weakSelf.playBtn.selected && !weakSelf.isDrop) {
            NSInteger currentTime = [weakSelf reloadTimeL];
            [weakSelf.slider setValue:(float)currentTime/(float)weakSelf.totalSec animated:YES];
            if (weakSelf.slider.value >= 1) {
                //这里是播放完毕的时刻
                [weakSelf play];
            }
        }
    }];
    */
}

- (void)playCurrentSong{
    //播放功能
    //图标 变为 暂停
    self.playSongBtn.hidden = YES;
    self.pauseSongBtn.hidden = NO;
    
    //开启定时
    [self.progresstimer setFireDate:[NSDate distantPast]];
    
    [[AVPlayerManager sharedManager] palySongAtOneTime:[AVPlayerManager sharedManager].player.currentTime];
    
    //中图开启动画
    [self startRotateAnimation:self.centerImg];
    [self startWaterRippleEffect:self.centerImg.frame];
}

- (void)pauseCurrentSong{
    //暂停功能
    //图标 变为 播放
    self.playSongBtn.hidden = NO;
    self.pauseSongBtn.hidden = YES;
    
    //关闭定时
    [self.progresstimer setFireDate:[NSDate distantFuture]];
//    [self.progresstimer invalidate];
    
    [[AVPlayerManager sharedManager] pauseSong];
    
    //中图停止动画
    [self stopRotateAnimation:self.centerImg];
    [self stopWaterRippleEffect];
}
- (void)previousSong{
    [[AVPlayerManager sharedManager] previousSong];
}

- (void)nextSong{
    [[AVPlayerManager sharedManager] nextSong];
}

- (void)changePlayingModel{
    [[AVPlayerQueueManager sharedManager] changePlayingModel];
    AVPlayerModelObj * model = [[AVPlayerQueueManager sharedManager] currentPlayingModel];
    [self.playModelBtn setImage:[UIImage imageNamed:model.model_image] forState:UIControlStateNormal];
}
//- (void)playOrPauseSong{
//
//
////    1.播放网络音频
////
////    NSURL * url  =[NSURL URLWithString:MP3URL];
////
////    AVPlayerItem* songItem =[[AVPlayerItem alloc]initWithURL:url];
////
////    self.avplayer=[[AVPlayer alloc]initWithPlayerItem:songItem];
////
////    [self.avplayer play];
////
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
//
//
////    NSURL *url = [NSURL fileURLWithPath:self.path];
////    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
//
////    2.播放本地音频
////
//    /*
//    NSString *tmp=[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"audio/move.mp3"];
//
//    NSLog(@"%@",tmp);
//
//    NSURL*moveMP3=[NSURL fileURLWithPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"audio/move.mp3"]];
//
//    NSError*err=nil;
//
//    self.movePlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:moveMP3 error:&err];
//
//    self.movePlayer.volume=1.0;
//
//    [self.movePlayer prepareToPlay];if(err!=nil) {
//
//    */
//    ///////////
////    [AVPlayerManager sharedManager].player = [AVPlayer playerWithPlayerItem:playerItem];
//
//    float status = [AVPlayerManager sharedManager].player.rate;
//    NSLog(@"播放与暂停-%f",[AVPlayerManager sharedManager].player.rate);
//    if( status == 0 ){
//        //暂停中
//        [[AVPlayerManager sharedManager] palySongAtOneTime:self.progressSlider.value];
////        [[AVPlayerManager sharedManager] playSongWithItem:[[AVPlayerQueueManager sharedManager] currentPlayingMusic]];
//
//        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"icon5.png"] forState:UIControlStateNormal];
//    }else if( status == 1 ){
//        //播放中
//        [[AVPlayerManager sharedManager] pauseSong];
//        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"icon2.png"] forState:UIControlStateNormal];
//
//        self.stopTime.text = [[AVPlayerManager sharedManager] durationOfSong];
//    }
//
//
//}

- (void)updatePerSecond{
    self.currentTime.text = [[AVPlayerManager sharedManager] currentTimeOfSong];
    self.progressSlider.value = [[AVPlayerManager sharedManager] currentProgressOfSong];
}

#pragma mark - 动画效果

- (void)startRotateAnimation:(UIImageView *)imageView{
    //开启旋转动画
    NSLog(@"旋转");
    CABasicAnimation * rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    //    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 20;//值越大越man
    rotationAnimation.autoreverses = NO;
    //    rotationAnimation.fillMode = kCAFillModeForwards;
//    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.repeatCount = MAXFLOAT;
    //MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    rotationAnimation.beginTime = CACurrentMediaTime();
//    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;//动画结束，停留在最后一帧
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//    NSLog(@"123456");
}

- (void)stopRotateAnimation:(UIImageView *)imageView{
    //关闭旋转动画
//    self.centerImg.layer.duration = MAXFLOAT;
    [self.centerImg.layer removeAnimationForKey:@"rotationAnimation"];
//    [self.centerImg.layer removeAllAnimations];
}

- (void)startWaterRippleEffect:(CGRect)frame{
    NSLog(@"开启水波纹效果");
    
    [self.mainView.layer removeAnimationForKey:@"animationGroup"];
    
    //开启水波纹效果
  
    // 2.创建一个图层对象 (原始层)
    CALayer * layer = [CALayer layer];
    // 2.1.设置layer对象的位置
//    layer.position = CGPointMake(self.centerImg.bounds.size.width, self.centerImg.bounds.size.height);
    // 2.2.设置layer对象的锚点
//    layer.anchorPoint = CGPointMake(0, 1);
    // 2.3.设置layer对象的位置大小
//    layer.bounds = CGRectMake(0, 0, self.frame.size.width*0.8, self.frame.size.width*0.8);
    
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.borderWidth = 3;
    layer.borderColor = orangeColor.CGColor;
    layer.frame = frame;
    layer.cornerRadius = frame.size.width/2;

//    layer.bounds          = CGRectMake(0, 0, 30, 30);
//    layer.position        = CGPointMake(self.view.center.x - 50, self.view.center.y - 50);


    //创建一个透明度动画
    CABasicAnimation * animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation1.fromValue          = @(0.2);
    animation1.toValue            = @(0.0);
    animation1.duration           = 2.5;
//    animation1.autoreverses       = NO;
    animation1.repeatCount = MAXFLOAT;
//    animation1.removedOnCompletion=NO;
//    [layer addAnimation:animation1 forKey:nil];
    
    //缩放动画
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:1.5];
    animation.duration=2.5;
//    animation.autoreverses=NO;
    animation.repeatCount=MAXFLOAT;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
//    [layer addAnimation:animation forKey:nil];
    
    //创建一个动画组, 将之前创建的透明度动画和缩放动画加入到这个动画组中
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.animations         = @[animation1,animation];
    animationGroup.duration           = 2.5;
    animationGroup.repeatCount        = MAXFLOAT;
    animationGroup.autoreverses       = NO;
//    ani.removedOnCompletion=NO;
    [layer addAnimation:animationGroup forKey:@"animationGroup"];
    /*
    // 3.创建一个基本动画
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    // 3.1.设置动画的属性
    //z顺，x逆，y中
    basicAnimation.keyPath = @"transform.scale.y";
    // 3.2.设置动画的属性值
    basicAnimation.toValue = @0.1;

    // 3.5.设置动画反转
    basicAnimation.autoreverses = NO;
    */
    
    // 1.创建一个复制图层对象，设置复制层的属性
    CAReplicatorLayer * replicatorLayer = [CAReplicatorLayer layer];
    // 1.1.设置复制图层中子层总数：这里包含原始层
    replicatorLayer.instanceCount = 5;
    // 1.2.设置复制子层偏移量
    //    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, 0, 0);
    // 1.3.设置复制层的动画延迟事件
    replicatorLayer.instanceDelay = 3;
    // 1.4.设置复制层的背景色，如果原始层设置了背景色，这里设置就失去效果
    //    replicatorLayer.instanceColor = [UIColor greenColor].CGColor;
    // 1.5.设置复制层颜色的偏移量
    //    replicatorLayer.instanceGreenOffset = -0.1;
    //    replicatorLayer.instanceColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    //    replicatorLayer.instanceGreenOffset = -0.03;       // 颜色值递减。
    //    replicatorLayer.instanceRedOffset = -0.02;         // 颜色值递减。
    //    replicatorLayer.instanceBlueOffset = -0.01;
    
    // 5.将layer层添加到复制层上
    [replicatorLayer addSublayer:layer];

    
    // 6.将复制层添加到view视图层上
    [self.mainView.layer addSublayer:replicatorLayer];
    
}

- (void)stopWaterRippleEffect{
    //关闭水波纹效果
    [self.mainView.layer removeAnimationForKey:@"animationGroup"];
}

@end
