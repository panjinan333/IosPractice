//
//  AVPlayerManager.h
//  IosPractice
//
//  Created by ltl on 2019/10/11.
//  Copyright © 2019 Yin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "AVPlayerQueueManager.h"
#import "AVPlayerQueueObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerItem * playerItem;

- (void)playSongWithItem:(AVPlayerQueueObj *)item;
- (void)pauseSong;
- (void)previousSong;
- (void)nextSong;
- (NSString *)durationOfSong;
- (NSString *)currentTimeOfSong;
- (double)currentProgressOfSong;
- (void)palySongAtOneTime:(CMTime)timePoint;

//@property (nonatomic, strong) CTCallCenter *callCenter ;
- (void)removePlayer;//移除播放器
@end

NS_ASSUME_NONNULL_END
