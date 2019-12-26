//
//  LocalMusicView.m
//  IosPractice
//
//  Created by ltl on 2019/10/25.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "LocalMusicView.h"
#import "Constants.h"
#import "AVPlayerQueueManager.h"
#import "AVPlayerManager.h"

@implementation LocalMusicView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.songListArray = [[NSMutableArray alloc] init];
//        NSString * source = [[NSBundle mainBundle] pathForResource:@"MusicSourceList" ofType:@"plist"];
//        NSArray * arr = [[NSMutableArray alloc] initWithContentsOfFile:source];
//        for(NSDictionary * dic in arr){
//            AVPlayerQueueObj * item = [[AVPlayerQueueObj alloc] init];
//            item.song_id = [[dic objectForKey:@"sonD"] integerValue];
//            item.song_path = [dic objectForKey:@"path"];
//            item.song_name = [dic objectForKey:@"name"];
//            item.song_image = [dic objectForKey:@"image"];
//            item.song_singer = [dic objectForKey:@"singer"];
//            [self.songListArray addObject:item];
//        }
        /*
        self.functionArray = [[NSMutableArray alloc] initWithObjects:@"本地音乐",@"最近播放",@"下载管理",@"我的收藏", nil];
        self.funcCollectionArray = [[NSMutableArray alloc] initWithObjects:@"私人FM",@"深夜电台",@"心动信号",@"专属推荐",@"跑步FM",@"驾驶模式",@"舒适空间",@"直播交友",nil];
        
        NSMutableArray * myCreate = [[NSMutableArray alloc] initWithObjects:@"我喜欢的音乐",@"抖腿神曲",@"FM预测",@"嵩嵩嵩",@"纯音乐",nil];
        NSMutableArray * mySave = [[NSMutableArray alloc] initWithObjects:@"入睡去",@"小小语种",@"精心学习",@"动漫经典",nil];
        self.songListArray = [[NSMutableArray alloc] initWithObjects:myCreate,mySave,nil];
        self.songListExtendArray = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"myCreate",
                                    @"1",@"mySave",
                                    nil];//1 ：默认展开
        */
        /*
        UITableView * functionTable = [[UITableView alloc] init];
        [functionTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"functionCell"];
        functionTable.backgroundColor = [UIColor clearColor];
        functionTable.tag = 1001;
        functionTable.bounces = NO;
        functionTable.delegate = self;
        functionTable.dataSource = self;
        self.functionTable = functionTable;
        [self addSubview:functionTable];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        UICollectionView * functionCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        functionCollection.backgroundColor = [UIColor clearColor];
        functionCollection.tag = 2001;
        functionCollection.delegate = self;
        functionCollection.dataSource = self;
        functionCollection.bounces = NO;
        functionCollection.showsHorizontalScrollIndicator = NO;
        [functionCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionItem"];
        functionCollection.backgroundColor = [UIColor clearColor];
        self.functionCollection = functionCollection;
        [self addSubview:functionCollection];
        */
        UITableView * songListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        [songListTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"localSongListCell"];
        songListTable.backgroundColor = [UIColor clearColor];
        songListTable.separatorColor = [UIColor clearColor];
        songListTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        songListTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        songListTable.sectionHeaderHeight = 0.000001;
        songListTable.sectionFooterHeight = 0.000001;
        songListTable.tag = 1001;
        songListTable.bounces = NO;
        songListTable.delegate = self;
        songListTable.dataSource = self;
        songListTable.estimatedRowHeight = 0;
        self.songListTable = songListTable;
        [self addSubview:songListTable];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    /*
    self.functionTable.frame = CGRectMake(0, 0, self.frame.size.width, self.functionArray.count * 60);
    self.functionCollection.frame = CGRectMake(0, self.functionTable.frame.origin.y + self.functionTable.frame.size.height + 20, self.frame.size.width, 100);
    CGFloat offset = self.functionCollection.frame.origin.y + self.functionCollection.frame.size.height + 10;
    */
    self.songListTable.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView.tag == 1001){
        return 1;
    }
//    else if(tableView.tag == 1002){
//        return 0;
//    }
    else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == 1001){
        return [self.songListArray count];
    }
//    else if(tableView.tag == 1002){
//        NSString * str;
//        if(section == 0){
//            str = [self.songListExtendArray valueForKey:@"myCreate"];
//        }else if(section == 1){
//            str = [self.songListExtendArray valueForKey:@"mySave"];
//        }else{
//            str = @"";
//        }
//        if([str isEqualToString:@"1"]){
//            NSMutableArray * list = [self.songListArray objectAtIndex:section];
//            return list.count;
//        }else{
//            return 0;
//        }
//    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 1001){
        static NSString * identifier = @"localSongListCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        AVPlayerQueueObj * item = [self.songListArray objectAtIndex:indexPath.row];
        if(item.song_image != nil){
            cell.imageView.image = [UIImage imageNamed:item.song_image];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"icon5.png"];
        }        
        cell.textLabel.text = item.song_name;
        cell.textLabel.textColor = themeColor;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString * identifier = @"";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        cell.imageView.image = [UIImage imageNamed:@"icon1.png"];
//        NSMutableArray * list = [self.songListArray objectAtIndex:indexPath.section];
//        cell.textLabel.text = [list objectAtIndex:indexPath.row];
//        cell.textLabel.textColor = themeColor;
//        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 1001){
        return 60;
    }else if(tableView.tag == 1002){
        return 0;
    }else{
        return 0;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if(tableView.tag == 1002){
//        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.songListTable.frame.size.width, 60)];
//        UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, header.frame.size.width - 10, header.frame.size.height)];
//        if(section == 0){
//            name.text = @"创建的歌单";
//        }else if(section == 1){
//            name.text = @"收藏的歌单";
//        }else{
//            name.text = @"";
//        }
//        name.textAlignment = NSTextAlignmentLeft;
//        name.textColor = themeColor;
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(isExtendTap:)];
//        header.tag = 500 + section;
//        [header addGestureRecognizer:tap];
//
//        [header addSubview:name];
//        return header;
//    }else{
//        return nil;
//    }
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if(tableView.tag == 1002){
//        return 50;
//    }else{
//        return 0;
//    }
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if(tableView.tag == 1002){
//        return 0.000001;
//    }else{
//        return 0;
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 1001){
        AVPlayerQueueObj * item = [self.songListArray objectAtIndex:indexPath.row];
        [[AVPlayerQueueManager sharedManager] addMusic:item];
        [[AVPlayerManager sharedManager] playSongWithItem:item];
        [self.songListTable reloadData];
//        if(indexPath.row == 0){
//            if (self.delegate && [self.delegate respondsToSelector:@selector(pushLocalMusicVC)]) {
//                [self.delegate pushLocalMusicVC];
//            }
//            //            LocalMusicViewController * vc = [[LocalMusicViewController alloc] init];
//        }
    }
}

/*
#pragma mark - is extend action

- (void)isExtendTap:(UIGestureRecognizer *)tap{
    NSString * section = [NSString stringWithFormat:@"%ld",tap.view.tag - 500];
    if([section isEqualToString:@"0"]){
        if( [[self.songListExtendArray valueForKey:@"myCreate"] integerValue] == 0){
            [self.songListExtendArray setObject:@"1" forKey:@"myCreate"];
        }else{
            [self.songListExtendArray setObject:@"0" forKey:@"myCreate"];
        }
    }else if([section isEqualToString:@"1"]){
        if( [[self.songListExtendArray valueForKey:@"mySave"] integerValue] == 0){
            [self.songListExtendArray setObject:@"1" forKey:@"mySave"];
        }else{
            [self.songListExtendArray setObject:@"0" forKey:@"mySave"];
        }
    }
    [self.songListTable reloadSections:[NSIndexSet indexSetWithIndex:[section integerValue]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - collection delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.funcCollectionArray.count;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString * identifier = @"collectionItem";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UICollectionViewCell alloc] init];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width*0.2, cell.frame.size.height*0.1, cell.frame.size.width*0.6, cell.frame.size.height*0.6)];
    img.image = [UIImage imageNamed:@"icon2.png"];
    [cell.contentView addSubview:img];
    UILabel * title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, cell.frame.size.height*0.7, cell.frame.size.width, cell.frame.size.height*0.3);
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = themeColor;
    title.text = [self.funcCollectionArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:title];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //内边距,「上左下右」
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    //水平间距
    return 10;
}

//垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake( 100, 100);
}
*/
@end
