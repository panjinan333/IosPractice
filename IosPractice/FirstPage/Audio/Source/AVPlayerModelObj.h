//
//  AVPlayerModelObj.h
//  IosPractice
//
//  Created by ltl on 2019/10/23.
//  Copyright © 2019 Yin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerModelObj : NSObject

@property (nonatomic, assign) NSInteger  model_id;
@property (nonatomic, strong) NSString * model_name;
@property (nonatomic, strong) NSString * model_type;
@property (nonatomic, strong) NSString * model_image;

@end

NS_ASSUME_NONNULL_END

