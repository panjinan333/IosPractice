//
//  AudioView.h
//  IosPractice
//
//  Created by ltl on 2019/10/9.
//  Copyright © 2019 Yin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioViewDelegate <NSObject>

/**
 * @brief 推出本地音乐
 */
- (void)pushLocalMusicVC;

@end

@interface AudioView : UIView<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) UITableView * functionTable;
@property(nonatomic, strong) UITableView * songListTable;
@property(nonatomic, strong) UICollectionView * functionCollection;
@property(nonatomic, strong) NSMutableArray * functionArray;
@property(nonatomic, strong) NSMutableArray * songListArray;
@property(nonatomic, strong) NSMutableDictionary * songListExtendArray;
@property(nonatomic, strong) NSMutableArray * funcCollectionArray;

@property(nonatomic, weak)   id<AudioViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
