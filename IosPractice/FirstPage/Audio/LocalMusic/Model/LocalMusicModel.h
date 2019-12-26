//
//  LocalMusicModel.h
//  IosPractice
//
//  Created by ltl on 2019/12/23.
//  Copyright © 2019 Yin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVPlayerQueueObj.h"
#import <MediaPlayer/MediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalMusicModel : NSObject

@property(nonatomic, strong) NSMutableArray<AVPlayerQueueObj *> * localSongListArray;

/**
 * @brief 请求内存访问权限
 */
- (void)requestMPMediaLibraryAuthorizationStatus;
- (void)getLocalMusic;

@end

NS_ASSUME_NONNULL_END
