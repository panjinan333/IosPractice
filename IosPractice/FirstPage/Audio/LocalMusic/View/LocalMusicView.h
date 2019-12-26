//
//  LocalMusicView.h
//  IosPractice
//
//  Created by ltl on 2019/10/25.
//  Copyright © 2019 Yin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVPlayerQueueObj.h"

NS_ASSUME_NONNULL_BEGIN

//@protocol AudioViewDelegate <NSObject>
//
///**
// * @brief 推出本地音乐
// */
//- (void)pushLocalMusicVC;
//
//@end

@interface LocalMusicView : UIView<UITableViewDelegate,UITableViewDataSource>

//@property(nonatomic, strong) UITableView * functionTable;
@property(nonatomic, strong) UITableView * songListTable;
//@property(nonatomic, strong) UICollectionView * functionCollection;
//@property(nonatomic, strong) NSMutableArray * functionArray;
@property(nonatomic, strong) NSMutableArray<AVPlayerQueueObj *> * songListArray;
//@property(nonatomic, strong) NSMutableDictionary * songListExtendArray;
//@property(nonatomic, strong) NSMutableArray * funcCollectionArray;

//@property(nonatomic, weak)   id<AudioViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
