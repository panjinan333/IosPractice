//
//  AVPlayerQueueManager.h
//  IosPractice
//
//  Created by ltl on 2019/10/14.
//  Copyright © 2019 Yin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVPlayerManager.h"
#import "AVPlayerQueueObj.h"
#import "AVPlayerModelObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerQueueManager : NSObject

+ (instancetype)sharedManager;

// 播放队列
- (NSMutableArray *)musicQueue;
// 当前正在播放的音乐
- (AVPlayerQueueObj *)currentPlayingMusic;
// 设置当前播放
- (void)setCurrentPlayingMusic:(AVPlayerQueueObj *)item;
// 返回上一首音乐
- (AVPlayerQueueObj *)previousMusic;
// 返回下一首音乐
- (AVPlayerQueueObj *)nextMusic;
// 添加音乐
- (void)addMusic:(AVPlayerQueueObj *)item;
// 删除队列中音乐
- (void)deleteMusic:(AVPlayerQueueObj *)item;


// 返回当前播放模式
- (AVPlayerModelObj *)currentPlayingModel;
// 返回当前播放模式列表
- (NSMutableArray *)playingModel;
// 改变播放模式
- (void)changePlayingModel;

typedef NS_ENUM(NSInteger, AVPlayerQueuePlayingModel) {
    AVPlayerQueuePlayingModelRandom  = 0,
    AVPlayerQueuePlayingModelSingle     = 1,
//    AVPlayerQueuePlayingModel  = 2,
//    AVPlayerQueuePlayingModel    = 3,
};

@end

NS_ASSUME_NONNULL_END
