//
//  AVPlayerQueueObj.h
//  IosPractice
//
//  Created by ltl on 2019/10/15.
//  Copyright © 2019 Yin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerQueueObj : NSObject

@property (nonatomic, assign) NSInteger  song_id;
@property (nonatomic, strong) NSString * song_path;
@property (nonatomic, strong) NSString * song_name;
@property (nonatomic, strong) NSString * song_singer;
@property (nonatomic, strong) NSString * song_image;

@end

NS_ASSUME_NONNULL_END
