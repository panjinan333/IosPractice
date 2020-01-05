//
//  AVPlayerManager.m
//  IosPractice
//
//  Created by ltl on 2019/10/11.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "AVPlayerManager.h"


@implementation AVPlayerManager

//对AVplayer进行 GCD方式单例创建
static AVPlayerManager * instance;
static dispatch_once_t onceToken;

+ (instancetype)sharedManager {
//    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AVPlayerManager alloc] init];        
    });
    //防止子类使用
//    if (![NSStringFromClass([self class]) isEqualToString:@"SCBLoadingShareView"]) {
//        //#define NSParameterAssert(condition) NSAssert((condition), @"Invalid parameter not satisfying: %@", @#condition)
//        //ios 是这么定义NSParameterAssert的
//        //传入nil会导致app崩溃
//        NSParameterAssert(nil);
//    }
    return instance;
}

- (void)removePlayer{
    onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
//    [instance release];
    instance = nil;
}

#pragma mark - play manage
//- (void)playSongWithItem:(AVPlayerQueueObj *)item{
//    NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:item.song_path]];
//    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:url];
//    self.player = [AVPlayer playerWithPlayerItem:playerItem];
//    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//}
- (void)playSongWithItem:(AVPlayerQueueObj *)item{
    //与当前播放进行比对，不一样则换歌
    AVPlayerQueueObj * current = [[AVPlayerQueueManager sharedManager] currentPlayingMusic];
    NSLog(@"******当前：%ld",(long)current.song_id);
    NSLog(@"******专辑：%ld",(long)item.song_id);
//    if( current.song_id != item.song_id ){
        //    //从文件中读取
        //    NSString * source = [[NSBundle mainBundle] pathForResource:@"MusicSourceList" ofType:@"plist"];
        //    NSArray * arr = [[NSArray alloc] initWithContentsOfFile:source];
        //    NSString * url0 = [[arr objectAtIndex:0] objectForKey:@"path"];
        //    NSLog(@"%@......",url0);
        
        [[AVPlayerQueueManager sharedManager] setCurrentPlayingMusic:item];
        
        //    NSString * tmp = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"IosPractice/FirstPage/Audio/Source/肖战 - 曲尽陈情.flac"];
        //    NSLog(@"ffff");
        //    NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"IosPractice/FirstPage/Audio/Source/曲尽陈情.flac"]];
        
        //已经是当前歌曲的话，不需要换歌
        NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:item.song_path]];
        AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:url];
        self.playerItem = playerItem;
        self.player = [AVPlayer playerWithPlayerItem:playerItem];

//    AVPlayerItem属性canPlaySlowForward或canPlayFastForward返回YES，则可以使用0.0和1.0之外的其他比率。如果AVPlayerItem的canPlayReverse，canPlaySlowReverse和canPlayFastReverse属性返回YES，则支持负值范围;
    NSLog(@"canPlayFastForward：%@",self.playerItem.canPlayFastForward?@"yes":@"no");
    NSLog(@"canPlaySlowForward：%@",self.playerItem.canPlaySlowForward?@"yes":@"no");
//    NSLog(@"canStepForward：%@",self.playerItem.canStepForward?@"yes":@"no");
//    NSLog(@"canStepForward：%@",self.playerItem.canStepForward?@"yes":@"no");
//    NSLog(@"canStepForward：%@",self.playerItem.canStepForward?@"yes":@"no");
//    NSLog(@"canStepForward：%@",self.playerItem.canStepForward?@"yes":@"no");
    
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听status属性（媒体加载状态）
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性//监听缓冲进度
        [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];// 缓冲区空了，需要等待数据
        //playbackLikelyToKeepUp和playbackBufferEmpty是一对，用于监听缓存足够播放的状态
        [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];

    
    /*
     监听
     AVF_EXPORT NSString *const AVPlayerItemTimeJumpedNotification             NS_AVAILABLE(10_7, 5_0);    // the item's current time has changed discontinuously
     //播放失败
     AVF_EXPORT NSString *const AVPlayerItemFailedToPlayToEndTimeNotification NS_AVAILABLE(10_7, 4_3);   // item has failed to play to its end time
     //异常中断
     AVF_EXPORT NSString *const AVPlayerItemPlaybackStalledNotification       NS_AVAILABLE(10_9, 6_0);    // media did not arrive in time to continue playback
     AVF_EXPORT NSString *const AVPlayerItemNewAccessLogEntryNotification     NS_AVAILABLE(10_9, 6_0);    // a new access log entry has been added
     AVF_EXPORT NSString *const AVPlayerItemNewErrorLogEntryNotification         NS_AVAILABLE(10_9, 6_0);    // a new error log entry has been added
     
     // notification userInfo key                                                                    type
     AVF_EXPORT NSString *const AVPlayerItemFailedToPlayToEndTimeErrorKey     NS_AVAILABLE(10_7, 4_3);   // NSError
     */
    
    //item播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
   
//        NSLog(@"前-状态：%f",self.player.rate);
    
    [self configPlayingInfo];
    [self createRemoteCommandCenter];
    //播放界面更新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMusicViewNSNotification" object:nil];
    //主窗口视图更新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMainViewNSNotification" object:nil];
    
//    }
    
    /// 添加监听.以及回调
//    __weak typeof(self) weakSelf = self;
//    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        /// 更新播放进度
////        [weakSelf updateProgress];
//    }];
//    拖拽方法如下：
//
//    - (IBAction)playerSliderValueChanged:(id)sender {
//        _isSliding = YES;
//        [self pause];    // 跳转到拖拽秒处
//        // self.playProgress.maxValue = value / timeScale
//        // value = progress.value * timeScale
//        // CMTimemake(value, timeScale) =  (progress.value, 1.0)
//        CMTime changedTime = CMTimeMakeWithSeconds(self.playProgress.value, 1.0);
//        [_playerItem seekToTime:changedTime completionHandler:^(BOOL finished) {
//            // 跳转完成后
//        }];
//    }
    /*
    __weak typeof(self)WeakSelf = self;
    __strong typeof(WeakSelf) strongSelf = WeakSelf;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC)
                                                queue:NULL
                                           usingBlock:^(CMTime time) {
                                               //进度 当前时间/总时间
                                               CGFloat progress = CMTimeGetSeconds(WeakSelf.avPlayer.currentItem.currentTime) / CMTimeGetSeconds(WeakSelf.avPlayer.currentItem.duration);
                                               //在这里截取播放进度并处理
                                               if (progress == 1.0f) {
                                                   //播放百分比为1表示已经播放完毕
                                                   WeakSelf.centerPlayBtn.hidden = NO;
                                                   //处理成员变量在block中报警告问题
                                                   strongSelf -> isplay = NO;
                                                   //改变播放按钮状态
                                                   [WeakSelf.bottomPlayBtn setImage:[UIImage imageNamed:@"视频播放"] forState:UIControlStateNormal];
                                                   //停止并移除计时器
                                                   [WeakSelf stopTimer];
                                                   [WeakSelf removeTimer];
                                                   //强制竖屏
                                                   [WeakSelf orientationToPortrait:UIInterfaceOrientationPortrait];
                                                   [WeakSelf endView];
                                               }
                                               
                                           }];
    */
//    //3 切换上一首或者下一首
//    [self.player replaceCurrentItemWithPlayerItem:songItem];
//    // 4.打印歌曲信息
//    @"音频文件声道数" =  self.audioPlayer.numberOfChannels;
//    @"音频文件持续时间" =  self.audioPlayer.duration;
//    // 4.设置循环播放
//    self.audioPlayer.volume = 1.0;
//    self.player.numberOfLoops = -1;
    
//    self.avPlayer.volume = 0;
//    self.avPlayer.volume = 3.0f;//音量
    //利用avplayer的currentItem属性，duration是总时间，currentTime是当前时间
//    NSInteger all = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
//    NSInteger now = CMTimeGetSeconds(self.avPlayer.currentItem.currentTime);
//    self.songSlide.value = CMTimeGetSeconds(self.avPlayer.currentItem.currentTime) / CMTimeGetSeconds(self.avPlayer.currentItem.duration);
//    需要获取当前播放的item可以这样获取：
    
//    AVPlayerItem * songItem = player.currentItem;
    
    
    
    /*
     NSURL * url  = [NSURL URLWithString:@"www.xxxxx.mp3"];
     NSURL * url2  = [[NSBundle mainBundle] URLForResource:@"mmusic" withExtension:@".mp3"];
     AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
     self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
     //AVPlayer * player = [[AVPlayer alloc] initWithURL:url];
     //AVPlayerItem * songItem = player.currentItem;
     //1播放
     [self.audioPlayer prepareToPlay];
     [self.player play];

     //3 切换上一首或者下一首
     [self.player replaceCurrentItemWithPlayerItem:songItem];
     // 4.打印歌曲信息
     @"音频文件声道数" =  self.audioPlayer.numberOfChannels;
     @"音频文件持续时间" =  self.audioPlayer.duration;
     // 4.设置循环播放
     self.audioPlayer.volume = 1.0;
     self.audioPlayer.numberOfLoops = -1;
     
     */
    
    //声音被打断的通知（电话打来）
//    AVAudioSessionInterruptionNotification
    //耳机插入和拔出的通知
//    AVAudioSessionRouteChangeNotification
    //进入后台
//    UIApplicationWillResignActiveNotification
    //返回前台
//    UIApplicationDidBecomeActiveNotification
    
}
//// 观察播放进度
//- (void)monitoringPlayback:(AVPlayerItem *)item {
//    __weak typeof(self)WeakSelf = self;
//
//    // 观察间隔, CMTime 为30分之一秒
//    _playTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        if (_touchMode != TouchPlayerViewModeHorizontal) {
//            // 获取 item 当前播放秒
//            float currentPlayTime = (double)item.currentTime.value/ item.currentTime.timescale;
//            // 更新slider, 如果正在滑动则不更新
//            if (_isSliding == NO) {
//                [WeakSelf updateVideoSlider:currentPlayTime];
//            }
//        } else {
//            return;
//        }
//    }];
//}
//注意： 给 palyer 添加了 timeObserver 后，不使用的时候记得移除 removeTimeObserver 否则会占用大量内存。

//比如，我在dealloc里面做了移除：
//
//- (void)dealloc {
//    [self removeObserveAndNOtification];
//    [_player removeTimeObserver:_playTimeObserver]; // 移除playTimeObserver}
- (void)pauseSong{
    //    NSLog(@"暂停qian断点:%@",[self currentTimeOfSong]);
    if(self.player.rate != 0.0){
        //播放中，才会变暂停
        [self.player pause];
    }
    //    NSLog(@"暂停hou断点:%@",[self currentTimeOfSong]);
}

- (void)previousSong{
    AVPlayerQueueObj * item = [[AVPlayerQueueManager sharedManager] previousMusic];
//    [[AVPlayerQueueManager sharedManager] setCurrentPlayingMusic:item];
//    [self removeObserverBeforePlay];
    [self playSongWithItem:item];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMusicViewNSNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMainViewNSNotification" object:nil];
}

- (void)nextSong{
    AVPlayerQueueObj * item = [[AVPlayerQueueManager sharedManager] nextMusic];
//    [[AVPlayerQueueManager sharedManager] setCurrentPlayingMusic:item];
//    [self removeObserverBeforePlay];
    [self playSongWithItem:item];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMusicViewNSNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMainViewNSNotification" object:nil];
}

#pragma mark - 监听

- (void)playDidEnd:(NSNotification *)notification{
    //播放完毕操作
    //确保在清理内存和视图期间将他们注销
    NSLog(@"正常 播放结束");
    //移除本身监听，通知
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //播放下一曲，并发送一个新的通知
    [self nextSong];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMusicViewNSNotification" object:nil];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMainViewNSNotification" object:nil];
}

- (void)removeObserverBeforePlay{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)palySongAtOneTime:(CMTime)timePoint{
    //通过以上方法我们也可以实现记录上次播放的时间节点,在下次播放时跳转到上次播放的地方,这里要注意的是必须要等到播放器准备好以后才可以调用seekToTime这个方法,否则会崩溃.通过KVO来监听status属性,当self.player.status == AVPlayerStatusReadyToPlay时调用seekToTime方法
    
    
    
//    NSLog(@"断点 跳转：%lld",timePoint.value);
//    NSLog(@"断点 跳转：%d",timePoint.timescale);
    //    CMTime timePoint = self.playerItem.asset.duration * timePoint;
    if(self.player.status == AVPlayerStatusReadyToPlay){
        [self.player seekToTime:timePoint toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
//        NSLog(@"断点 跳转 当前：%@",[self currentTimeOfSong]);
//        NSLog(@"断点 跳转 总时：%@",[self durationOfSong]);
    }
    
    //    self.player
    //    NSLog(@"断点 续播 时间:%@",[self currentTimeOfSong]);
    [self.player play];
}
- (NSString *)durationOfSong{
    //利用AVPlayer的CMTime属性,它由value和timeScale组成,前者除以后者就可以得出秒数
//    CMTime duration = self.playerItem.duration;// 获取视频总长度
//    CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
    //加上歌曲判断 不然返回nan
    CMTime totalTime = self.playerItem.asset.duration;
    Float64 time = CMTimeGetSeconds(totalTime);
    NSLog(@"总秒：%f",time);
    int minute = (int)(time+1)/60;
    int second = (int)(time+1)%60;
//    NSLog(@"总时间:%d",(int)time+1);
//    return [NSString stringWithFormat:@"%d",(int)time+1];
    return [NSString stringWithFormat:@"%02d:%02d",minute, second];
}

- (NSString *)currentTimeOfSong{
//    [self durationOfSong];
    CMTime currentTime = self.player.currentItem.currentTime;
//    NSTimeInterval currentTimeSec = time.value / time.timescale;
//    CMTime currentTime = self.player.currentItem.duration;
    
    Float64 time = CMTimeGetSeconds(currentTime);
    
    NSLog(@"当前秒：%f",time);
//    CMTime totalTime = self.playerItem.asset.duration;
    CMTime totalTime = self.playerItem.duration;
    Float64 time1 = CMTimeGetSeconds(totalTime);
    NSLog(@"总的秒：%f",time1);
    
    int minute,second;
    if(time == 0.000000){
        //item开始的一瞬间
        minute = 0;
        second = 0;
    }else{
        minute = (int)(time+1)/60;
        second = (int)(time+1)%60;
    }
//    NSLog(@"当前时间:%d",(int)time+1);
//    return [NSString stringWithFormat:@"%d",(int)time+1];
    return [NSString stringWithFormat:@"%02d:%02d",minute, second];
}

- (double)currentProgressOfSong{
    CMTime cur = self.player.currentItem.currentTime;
    CMTime all = self.player.currentItem.duration;
//    NSLog(@"进度-%@",[NSString stringWithFormat:@"%f",CMTimeGetSeconds(cur)/CMTimeGetSeconds(all)]);
//    return [NSString stringWithFormat:@"%f",CMTimeGetSeconds(cur)/CMTimeGetSeconds(all)];
    return CMTimeGetSeconds(cur)/CMTimeGetSeconds(all);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //状态监听
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"情况未知");
//                BASE_INFO_FUN(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                //准备播放
                [self enableAudioTracks:YES inPlayerItem:self.playerItem];
                self.player.rate = 1.5;
                self.playerItem.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmTimeDomain;
                [self.player play];
                
                NSLog(@"后-状态：%f",self.player.rate);
                //        //获取视频的总播放时长
                //        self.total = CMTimeGetSeconds(self.avPlayer.currentItem.duration);

                //播放界面状态更新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMusicStateNSNotification" object:nil];
                //主窗口状态更新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMainStateNSNotification" object:nil];
                
//                self.status = SUPlayStatusReadyToPlay;

                break;
            case AVPlayerStatusFailed:
                [self.player pause];
                NSLog(@"播放失败");
                break;
            default:
                break;
        }
    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //获取缓冲进度
        NSArray * loadedTimeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
//        NSArray * loadedTimeRanges = [playerItem loadedTimeRanges];
        //        NSArray * array = songItem.loadedTimeRanges;

//         获取缓冲区域 //本次缓冲的时间范围
            CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        //        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];

            //开始的时间
            NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
            //表示已经缓冲的时间
            NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
            // 计算缓冲总时间
            NSTimeInterval result = startSeconds + durationSeconds;
            NSLog(@"开始:%f,持续:%f,总时间:%f", startSeconds, durationSeconds, result);
//            NSLog(@"视频的加载进度是:%%%f", durationSeconds / self.total * 100);
        

        if (loadedTimeRanges && [loadedTimeRanges count]) {
            CMTime bufferDuration = CMTimeAdd(timeRange.start, timeRange.duration);
            // 获取到缓冲的时间,然后除以总时间,得到缓冲的进度
            NSLog(@"缓冲%f",CMTimeGetSeconds(bufferDuration));
        }
    }
}








- (void)updateLoadedTimeRanges:(NSArray *)timeRanges {
    if (timeRanges && [timeRanges count]) {
        CMTimeRange timerange = [[timeRanges firstObject] CMTimeRangeValue];
        CMTime bufferDuration = CMTimeAdd(timerange.start, timerange.duration);
        // 获取到缓冲的时间,然后除以总时间,得到缓冲的进度
        NSLog(@"缓冲%f",CMTimeGetSeconds(bufferDuration));
    }
}

- (void)enableAudioTracks:(BOOL)enable inPlayerItem:(AVPlayerItem*)playerItem
{
    for (AVPlayerItemTrack *track in playerItem.tracks)
    {
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeAudio])
        {
            track.enabled = enable;
        }
    }
}

//- (void)seekToTime:(CMTime)time;
//- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler NS_AVAILABLE(10_7, 5_0);
//- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter;
////此方法包含回调事件
//- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^)(BOOL finished))completionHandler NS_AVAILABLE(10_7, 5_0);


/*
 读取本地音乐

MPMediaPropertyPredicate *albumNamePredicate =

[MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];

[everything addFilterPredicate:albumNamePredicate];

_itemsFromGenericQuery = [everything items];
*/

// 添加远程控制
- (void)createRemoteCommandCenter {
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
//
    MPRemoteCommand *pauseCommand = [commandCenter pauseCommand];
    [pauseCommand setEnabled:YES];
//    [pauseCommand addTarget:self action:@selector(remotePauseEvent)];
//
    MPRemoteCommand *playCommand = [commandCenter playCommand];
    [playCommand setEnabled:YES];
//    [playCommand addTarget:self action:@selector(remotePlayEvent)];
//
    MPRemoteCommand *nextCommand = [commandCenter nextTrackCommand];
    [nextCommand setEnabled:YES];
//    [nextCommand addTarget:self action:@selector(remoteNextEvent)];
//
    MPRemoteCommand *previousCommand = [commandCenter previousTrackCommand];
    [previousCommand setEnabled:YES];
//    [previousCommand addTarget:self action:@selector(remotePreviousEvent)];
//
//    if (@available(iOS 9.1, *)) {
//        MPRemoteCommand *changePlaybackPositionCommand = [commandCenter changePlaybackPositionCommand];
//        [changePlaybackPositionCommand setEnabled:YES];
//        [changePlaybackPositionCommand addTarget:self action:@selector(remoteChangePlaybackPosition:)];
//    }
}

//2.锁屏状态下的歌曲名、歌手名、专辑图设置
- (void)configPlayingInfo{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")){
        NSLog(@"锁屏UI设置");
        // 1.获取锁屏中心
        MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
        // 初始化一个存放音乐信息的字典
        NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
        
        // 2、设置歌曲名
        [playingInfoDict setObject:@"hhah"
                            forKey:MPMediaItemPropertyTitle];
        [playingInfoDict setObject:@"hhah"
                            forKey:MPMediaItemPropertyAlbumTitle];
        
        // 3、设置封面的图片
//        UIImage *image = [UIImage imageNamed:@"songImage_3.png"];
//        if (image) {
//            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:<#(CGSize)#> requestHandler:<#^UIImage * _Nonnull(CGSize size)requestHandler#>];
//            [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
//        }
        
        // 4、设置歌曲的时长和已经消耗的时间
        NSNumber *playbackDuration = @(CMTimeGetSeconds(_player.currentItem.duration));
        NSNumber *elapsedPlaybackTime = @(CMTimeGetSeconds(_player.currentItem.currentTime));
        
        if (!playbackDuration || !elapsedPlaybackTime) {
            return;
        }
        
        [playingInfoDict setObject:playbackDuration
                            forKey:MPMediaItemPropertyPlaybackDuration];
        [playingInfoDict setObject:elapsedPlaybackTime
                            forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
//        [playingInfoDict setObject:@(_player.rate) forKey:MPNowPlayingInfoPropertyPlaybackRate];
        
        //音乐信息赋值给获取锁屏中心的nowPlayingInfo属性
        playingInfoCenter.nowPlayingInfo = playingInfoDict;
        
//        if (@available(iOS 9.0, *)) {//判断是不是iOS 11
//            //根据当前播放器的播放状态显示控制器中心的播放状态
//            if (self.player.rate) {
//                [MPNowPlayingInfoCenter defaultCenter].playbackState =
//                    MPNowPlayingPlaybackStatePaused;
//            }else {
//                [MPNowPlayingInfoCenter defaultCenter].playbackState = MPNowPlayingPlaybackStatePlaying;
//            }
//        }
        
   
        // 直接使用defaultCenter来获取MPNowPlayingInfoCenter的默认唯一实例
//        MPNowPlayingInfoCenter * infoCenter = [MPNowPlayingInfoCenter defaultCenter];
//
//        // MPMediaItemArtwork 用来表示锁屏界面图片的类型
//        MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"songImage_3.png"]];
//
//        // 通过配置nowPlayingInfo的值来更新锁屏界面的信息
//        infoCenter.nowPlayingInfo = @{
//                                      // 歌曲名
//                                      MPMediaItemPropertyTitle : @"hahaha",
//                                      // 艺术家名
//                                      MPMediaItemPropertyArtist : @"hahaha",
//                                      // 专辑名字
//                                      MPMediaItemPropertyAlbumTitle : @"hahaha",
//                                      // 歌曲总时长
////                                      MPMediaItemPropertyPlaybackDuration : @(duration),
//                                      // 歌曲的当前时间
////                                      MPNowPlayingInfoPropertyElapsedPlaybackTime : @(currentTime),
//                                      // 歌曲的插图, 类型是MPMeidaItemArtwork对象
//                                      MPMediaItemPropertyArtwork : artwork,
//
//                                      // 无效的, 歌词的展示是通过图片绘制完成的, 即将歌词绘制到歌曲插图, 通过更新插图来实现歌词的更新的
//                                      // MPMediaItemPropertyLyrics : lyric.content,
//                                      };
        
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//
//        if (_songName&&_singer) {
//
//
//
//            [dict setObject:_songName forKey:MPMediaItemPropertyTitle];//歌曲名设置
//
//            [dict setObject:_singer forKey:MPMediaItemPropertyArtist];//歌手名设置
//
//            if (![imgURL isEqualToString:@"专辑默认背景"] && imgURL.length > 0 )
//
//            {
//
//                [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL] options:NSUTF8StringEncoding error:nil]]]  forKey:MPMediaItemPropertyArtwork];//专辑图片设置
//
//            }
//
//            else
//
//            {
//
//                [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"专辑默认背景"]] forKey:MPMediaItemPropertyArtwork];//专辑图片设置
//
//            }
//
//        }
//
//        [dict setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(self.avplayer.currentItem.currentTime)] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经播放时间
//
//        [dict setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度（这个随自己的播放速率调整，默认是原速播放）
//
//        [dict setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(self.avplayer.currentItem.duration)] forKey:MPMediaItemPropertyPlaybackDuration];//歌曲总时间设置
//
//        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
    
}

/*
3.如果播放的歌曲为网络歌曲，则要设置一下后台控制打断的事件，否则无法进行正常的自动下一曲

//后台播放相关,且将蓝牙重新连接

-(void)setAudioSession{
    
    //AudioSessionInitialize用于控制打断
    
    //这种方式后台，可以连续播放非网络请求歌曲，遇到网络请求歌曲就废,需要后台申请task
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    
    BOOL success = [session setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    
    if (!success)
        
    {
        
        return;
        
    }
    
    NSError *activationError = nil;
    
    success = [session setActive:YES error:&activationError];
    
    if (!success)
        
    {
        
        return;
        
    }
    
}



5.在播放器程序中一点小的心得

如果要让播放器接受远程控制则要设置第一响应状态

　 [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

　 [self becomeFirstResponder];

//设置为第一响应

-(BOOL)canBecomeFirstResponder{
    
    return YES;
    
}

后台控制（耳机线控制）
*/




/*
-(void)showInfoInLockedScreen:(SWTMusic*)music
{
    //  这种方式，不能将信息正确显示在锁屏上
    //    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    //    info[MPMediaItemPropertyTitle] = music.name;
    //    info[MPMediaItemPropertyArtist] = music.singer;
    //    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:music.icon]];
    //
    //    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
    
    
    NSMutableDictionary *songInfo = [ [NSMutableDictionary alloc] init];
    
    MPMediaItemArtwork *albumArt = [ [MPMediaItemArtwork alloc] initWithImage: [UIImage imageNamed:music.icon]];
    //设置播放进度条
    double currentTime = self.currentAudioPlayer.currentTime;
    double duration = self.currentAudioPlayer.duration ;
    
    [ songInfo setObject:music.name forKey:MPMediaItemPropertyTitle ];
    [ songInfo setObject:music.singer forKey:MPMediaItemPropertyArtist ];
    [ songInfo setObject:music.singer forKey:MPMediaItemPropertyAlbumTitle ];
    [ songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork ];
    
    [songInfo setObject:@(currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [songInfo setObject:@(duration) forKey:MPMediaItemPropertyPlaybackDuration];
    [ [MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo ];
    
    
}
*/


//[self.playerItem removeObserver:self forKeyPath:kStatusKey context:AVARLDelegateDemoViewControllerStatusObservationContext];
//
//　　 [self.player removeObserver:self forKeyPath:kRateKey context:AVARLDelegateDemoViewControllerRateObservationContext];
//　[self.player removeObserver:self forKeyPath:kCurrentItemKey context:AVARLDelegateDemoViewControllerCurrentItemObservationContext];

//四、遇到的问题
//1.只添加MPMediaItemPropertyPlaybackDuration（歌曲总时间）
//问题：不显示当前进度
//解决：添加MPMediaItemPropertyPlaybackDuration同时也出现问题，剩余时间每次减2秒
//
//2.添加了MPMediaItemPropertyPlaybackDuration和MPNowPlayingInfoPropertyElapsedPlaybackTime
//问题：出现了剩余时间每次减2秒的情况
//解决：要添加MPNowPlayingInfoPropertyPlaybackRate就可以
//
//3.暂停恢复播放更新 锁屏进度条
//
//NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
//[dict setObject:[NSNumber numberWithDouble:audioPlayer.playableDuration] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经过时间
//[[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];

//通过seekToTime这个方法可以用来跳转到视频的某个时间点,传入的值也是CMTime类型的
//通过以上方法我们也可以实现记录上次播放的时间节点,在下次播放时跳转到上次播放的地方,这里要注意的是必须要等到播放器准备好以后才可以调用seekToTime这个方法,否则会崩溃.通过KVO来监听status属性,当self.player.status == AVPlayerStatusReadyToPlay时调用seekToTime方法
//- (void)closePlayer{
//    [self.player.currentItem cancelPendingSeeks];
//    [self.player.currentItem.asset cancelLoading];
//    self.playerItem = nil;
//    [self.player replaceCurrentItemWithPlayerItem:nil];
//    _player = nil;
//    self.ratevalue = 1.0;
//    self.callCenter = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//}


//3，使用代码如下：
//
//CTCallCenter *center = [[CTCallCenter alloc] init];
//center.callEventHandler = ^(CTCall *call){
//    //block回调
//    NSLog(@"----->>>>Call State : %@",[call description]);
//
//    if (call.callState == CTCallStateDisconnected){
//        NSLog(@"Call has been disconnected---挂断");
//    }else if (call.callState == CTCallStateConnected){
//        NSLog(@"Call has just been connected---通话中");
//    }else if(call.callState == CTCallStateIncoming){
//        NSLog(@"Call is incoming---来电中(未接起)");
//    }else if (call.callState ==CTCallStateDialing){
//        NSLog(@"call is dialing");
//    }else{
//        NSLog(@"Nothing is done");
//    }
//
//};
//进行初始化完后，就可以测试啦。给被测试的手机打电话，就会执行^(CTCall *call)回调中的代码，通过[call description]可以看出手机通话的各种状态。
//
//特别注意，这是iOS的私有API，不能上线AppStore会被拒；而且在项目中定义全局属性变量(@property (nonatomic,retain)CTCallCenter * center;)编译也不会通过！！！！
@end
