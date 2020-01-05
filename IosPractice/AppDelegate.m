//
//  AppDelegate.m
//  IosPractice
//
//  Created by ltl on 2019/10/8.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AudioViewController.h"
#import "AVPlayerManager.h"
#import "AVPlayerQueueManager.h"
#import "AVPlayerQueueObj.h"
#import "AVPlayerModelObj.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //app启动，视图控制从此开始
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //根视图控制
    //1.
//    self.window.rootViewController = [[ViewController alloc] init];
    //2.
    ViewController * view = [[ViewController alloc] init];
    [self.window setRootViewController:view];
    
    [self.window makeKeyAndVisible];
    
    //开启接收远程控制,并成为第一响应
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
//    [self setupLockScreenInfo];
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    //当应用程序即将从活动状态移动到非活动状态时发送。这可能发生在某些类型的临时中断(如来电或短信)，或者当用户退出应用程序并开始过渡到后台状态时。
    //使用这个方法来暂停正在进行的任务，禁用定时器，使图形渲染回调无效。游戏应该使用这种方法暂停游戏。
    
    //在程序即将失去焦点applicationWillResignActive:时，开启后台播放：
    //获取音频会话
    AVAudioSession * session = [AVAudioSession sharedInstance];
    //激活音频会话（静音状态依旧可以播放）
    [session setActive:YES error:nil];
    //设置音频会话类型，后台播放，锁屏后也可播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
// MPNowPlayingInfoCenter
    
    //录音和回放
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord
//             withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
//                   error:nil];

    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //使用此方法来释放共享资源、保存用户数据、使计时器失效，并存储足够的应用程序状态信息，以便在以后终止应用程序时将其恢复到当前状态。
    //如果你的应用程序支持后台执行，这个方法会被调用，而不是applicationWillTerminate:当用户退出时。
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //调用，作为从后台到活动状态转换的一部分;在这里，您可以撤消在进入后台时所做的许多更改。
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //重新启动在应用程序处于非活动状态时暂停(或尚未启动)的任何任务。如果应用程序以前在后台，可以选择刷新用户界面。
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //在应用程序即将终止时调用。适当时保存数据。看到也applicationDidEnterBackground:。
    
    //记录播放队列
    NSMutableArray * queue = [[AVPlayerQueueManager sharedManager] musicQueue];
    [[NSUserDefaults standardUserDefaults] setObject:queue forKey:@"AVPlayerQueue"];
    //记录当前播放
    AVPlayerQueueObj * currentSong = [[AVPlayerQueueManager sharedManager] currentPlayingMusic];
    [[NSUserDefaults standardUserDefaults] setObject:currentSong forKey:@"AVPlayerCurrentSong"];
    //记录播放模式
    AVPlayerModelObj * currentModel = [[AVPlayerQueueManager sharedManager] currentPlayingModel];
    [[NSUserDefaults standardUserDefaults] setObject:currentModel forKey:@"AVPlayerCurrentModel"];
    
    // 在App要终止前结束接收远程控制事件, 也可以在需要终止时调用该方法终止
//    [application endReceivingRemoteControlEvents];
}

#pragma mark - 锁屏
- (BOOL)canBecomeFirstResponder{
    return  YES;
}
#pragma mark - 设置锁屏界面的信息
- (void)setupLockScreenInfo
{
    // 1.获取当前正在播放的歌曲
//    ChaosMusic *playingMusic = [ChaosMusicTool playingMusic];
    // 2.获取锁屏界面中心
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    // 3.设置展示的信息
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
    
    playingInfo[MPMediaItemPropertyAlbumTitle] = @"yha";
    playingInfo[MPMediaItemPropertyArtist] = @"erha";
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"icon1.png"]];
    playingInfo[MPMediaItemPropertyArtwork] = artwork;
//    playingInfo[MPMediaItemPropertyArtist] = @(self.player.currentTime);
    
    playingCenter.nowPlayingInfo = playingInfo;
    // 4.让应用程序可以接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
//在AppDelegate中实现处理接收到远程控制的方法remoteControlReceivedWithEvent
// 在具体的控制器或其它类中捕获处理远程控制事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    switch (event.subtype) {
            // 根据事件的子类型(subtype) 来判断具体的事件类型, 并做出处理
        case UIEventSubtypeRemoteControlPause:
            // 执行播放或暂停的相关操作 (锁屏界面和上拉快捷功能菜单处的播放按钮)
//            [self.currentAudioPlayer pause];
//            [[PlayController  sharedInstance] pause];
            
            NSLog(@"RemoteControlEvents: pause");
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            // 执行下一曲的相关操作 (锁屏界面和上拉快捷功能菜单处的下一曲按钮)
            [[AVPlayerManager sharedManager] nextSong];
            NSLog(@"RemoteControlEvents: playModeNext");
            /*
            if (self.rotateCell) {
                [self.rotateCell stopRotate];
                
                NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                SWTMusic *music = self.musicArray[indexPath.item];
                [SWTMusicTool stopMusic:music.filename];
                int index = indexPath.item + 1;
                if (index >= self.musicArray.count) {
                    index = 0;
                }
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
                [self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                SWTMusicCell *cell = [self.tableView cellForRowAtIndexPath:newIndexPath];
                self.rotateCell = cell;
                [cell startRotate];
                SWTMusic *nextMusic = self.musicArray[index];
                [self showInfoInLockedScreen:nextMusic];
                self.currentAudioPlayer = [SWTMusicTool playMusic:nextMusic.filename];
                self.currentAudioPlayer.delegate = self;
                
            }
            */
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            // 执行上一曲的相关操作 (锁屏界面和上拉快捷功能菜单处的上一曲按钮)
            [[AVPlayerManager sharedManager] previousSong];
            NSLog(@"RemoteControlEvents: playPrev");
            /*
            if (self.rotateCell) {
                [self.rotateCell stopRotate];
                
                NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                int index = indexPath.item - 1;
                if (index < 0) {
                    index = self.musicArray.count-1;
                }
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
                SWTMusic *music = self.musicArray[indexPath.item];
                [SWTMusicTool stopMusic:music.filename];
                
                [self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                SWTMusicCell *cell = [self.tableView cellForRowAtIndexPath:newIndexPath];
                self.rotateCell = cell;
                [cell startRotate];
                SWTMusic *nextMusic = self.musicArray[index];
                [self showInfoInLockedScreen:nextMusic];
                self.currentAudioPlayer = [SWTMusicTool playMusic:nextMusic.filename];
                self.currentAudioPlayer.delegate = self;
                
            }
            */
            break;
        case UIEventSubtypeRemoteControlPlay:
//            [self.currentAudioPlayer play];
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause: {
            // 进行播放/暂停的相关操作 (耳机的播放/暂停按钮)
            break;
        }
        default:
            break;
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kAppDidReceiveRemoteControlNotification object:nil userInfo:orderDict];
}
-  (void)playBtnClicked

{
    
    NSError  *error  =  nil;
    
    NSString  *path  =  [[NSBundle  mainBundle] pathForResource:@"music" ofType:@"mp3"];
    
    AVAudioPlayer  *player  =  [[AVAudioPlayer  alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:&error];
    
    if  (error)  {
        
        NSLog(@"Error:%@",  [error localizedDescription]);
        
    }
    
    [player play];
    
}
// 在需要处理远程控制事件的具体控制器或其它类中实现
- (void)remoteControlEventHandler
{/*
    // 直接使用sharedCommandCenter来获取MPRemoteCommandCenter的shared实例
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)
    commandCenter.playCommand.enabled = YES;
    // 为播放命令添加响应事件, 在点击后触发
    [commandCenter.playCommand addTarget:self action:@selector(playAction:)];
    
    // 播放, 暂停, 上下曲的命令默认都是启用状态, 即enabled默认为YES
    // 为暂停, 上一曲, 下一曲分别添加对应的响应事件
    [commandCenter.pauseCommand addTarget:self action:@selector(pauseAction:)];
    [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackAction:)];
    [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackAction:)];
    
    // 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
    commandCenter.togglePlayPauseCommand.enabled = YES;
    // 为耳机的按钮操作添加相关的响应事件
    [commandCenter.togglePlayPauseCommand addTarget:self action:@selector(playOrPauseAction:)];
*/
  }
- (void)updatelockScreenInfo
{/*
    // 直接使用defaultCenter来获取MPNowPlayingInfoCenter的默认唯一实例
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // MPMediaItemArtwork 用来表示锁屏界面图片的类型
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]     initWithImage:image];
    
    // 通过配置nowPlayingInfo的值来更新锁屏界面的信息
    infoCenter.nowPlayingInfo = @{
                                  // 歌曲名
                                  MPMediaItemPropertyTitle : music.name,
                                  // 艺术家名
                                  MPMediaItemPropertyArtist : music.singer,
                                  // 专辑名字
                                  MPMediaItemPropertyAlbumTitle : music.album,
                                  // 歌曲总时长
                                  MPMediaItemPropertyPlaybackDuration : @(duration),
                                  // 歌曲的当前时间
                                  MPNowPlayingInfoPropertyElapsedPlaybackTime : @(currentTime),
                                  // 歌曲的插图, 类型是MPMeidaItemArtwork对象
                                  MPMediaItemPropertyArtwork : artwork,
                                  
                                  // 无效的, 歌词的展示是通过图片绘制完成的, 即将歌词绘制到歌曲插图, 通过更新插图来实现歌词的更新的
                                  // MPMediaItemPropertyLyrics : lyric.content,
                                  };
    */
}

@end
