//
//  AVPlayerQueueView.m
//  IosPractice
//
//  Created by ltl on 2019/10/21.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "AVPlayerQueueView.h"
#import "AVPlayerQueueManager.h"
#import "AVPlayerQueueObj.h"
#import "AVPlayerManager.h"
#import "Constants.h"

#define background [UIColor colorWithRed:110.0/255.0 green:123.0/255.0 blue:139.0/255.0 alpha:1.0]

@implementation AVPlayerQueueView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.alpha = 1.0;
        
        UIView * header = [[UIView alloc] init];
        header.backgroundColor = background;
        self.header = header;
        [self addSubview:header];
        
        UITableView * palyerQueueTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [palyerQueueTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"palyerQueueCell"];
        palyerQueueTable.backgroundColor = background;
        palyerQueueTable.separatorColor = [UIColor clearColor];
        palyerQueueTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        palyerQueueTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        palyerQueueTable.sectionHeaderHeight = 0.000001;
        palyerQueueTable.sectionFooterHeight = 0.000001;
        palyerQueueTable.tag = 1002;
        palyerQueueTable.bounces = NO;
        palyerQueueTable.delegate = self;
        palyerQueueTable.dataSource = self;
        palyerQueueTable.estimatedRowHeight = 0;
        self.palyerQueueTable = palyerQueueTable;
        [self addSubview:palyerQueueTable];
        
        self.palyerQueueArray = [[AVPlayerQueueManager sharedManager] musicQueue];
        
        UIImageView * modelImg = [[UIImageView alloc] init];
        modelImg.userInteractionEnabled = YES;
        self.modelImg  = modelImg;
        [self.header addSubview:modelImg];
        
        UILabel * playModel = [[UILabel alloc] init];
        playModel.userInteractionEnabled = YES;
        playModel.textColor = themeColor;
        playModel.text = @"666";
        self.playModel = playModel;
        [self.header addSubview:playModel];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeModel)];
        [self.modelImg addGestureRecognizer:tap];
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeModel)];
        [self.playModel addGestureRecognizer:tap1];
        
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideList)];
        tap2.delegate = self;
        [self addGestureRecognizer:tap2];
        
        UIImageView * deleteAll = [[UIImageView alloc] init];
        deleteAll.userInteractionEnabled = YES;
        deleteAll.image = [UIImage imageNamed:@"delete1.png"];
        self.deleteAll  = deleteAll;
        [self.header addSubview:deleteAll];
        
        
        UILabel * line = [[UILabel alloc] init];
        line.backgroundColor = themeColor;
        self.line = line;
        [self.header addSubview:line];
        
        /*
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        self.effectView = effectView;
        [self addSubview:effectView];
        
        
        
        UIButton * playOrPauseBtn = [[UIButton alloc] init];
        [playOrPauseBtn setImage:[UIImage imageNamed:@"icon3.png"] forState:UIControlStateNormal];
//        self.playOrPauseBtn = playOrPauseBtn;
        [effectView.contentView addSubview:playOrPauseBtn];
        
        UIButton * songListBtn = [[UIButton alloc] init];
        [songListBtn setImage:[UIImage imageNamed:@"icon3.png"] forState:UIControlStateNormal];
//        self.songListBtn = songListBtn;
        [effectView.contentView addSubview:songListBtn];
        
        
        
        
        
        
//        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDetail)];
//        [self.songName addGestureRecognizer:tap1];
//        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDetail)];
//        [self.singerName addGestureRecognizer:tap2];
        
        
         */
        [self refreshModelUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.palyerQueueTable.frame = CGRectMake(0, self.frame.size.height - self.frame.size.width, self.frame.size.width, self.frame.size.width);
    self.header.frame = CGRectMake(0, self.palyerQueueTable.frame.origin.y - 50, self.frame.size.width, 50);
    self.modelImg.frame = CGRectMake(15, 15, self.header.frame.size.height - 30, self.header.frame.size.height - 30);
    self.playModel.frame = CGRectMake( self.modelImg.frame.origin.x +  self.modelImg.frame.size.width + 5, 0, 80, self.header.frame.size.height);
    self.deleteAll.frame = CGRectMake(self.header.frame.size.width - self.header.frame.size.height + 15, 15, self.header.frame.size.height - 30, self.header.frame.size.height - 30);
    self.line.frame = CGRectMake(0, 50 - 0.3, self.frame.size.width, 0.3);
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.header.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.header.bounds;
    maskLayer.path = maskPath.CGPath;
    self.header.layer.mask = maskLayer;
    // UIRectCornerTopLeft      左上角
    // UIRectCornerTopRight     右上角
    // UIRectCornerBottomLeft   左下角
    // UIRectCornerBottomRight  右下角
    // UIRectCornerAllCorners   四个角
    // byRoundingCorners: 参数可以选择上面五种，需要制定某几个角为圆角，就要用 “|” 组合
    // cornerRadii: 代表圆角值大小
    
//    self.songPhotoImg.layer.cornerRadius = self.songPhotoImg.frame.size.height/2;
//
    
//    self.songListBtn.frame = CGRectMake(self.effectView.frame.size.width - self.effectView.frame.size.height + 10, 10, self.effectView.frame.size.height - 20, self.effectView.frame.size.height - 20);
//
//    self.songName.frame = CGRectMake(self.effectView.frame.size.height + 5, 0, self.effectView.frame.size.width - self.effectView.frame.size.height * 3 - 5, self.effectView.frame.size.height / 2);
//    self.singerName.frame = CGRectMake(self.effectView.frame.size.height + 5, self.effectView.frame.size.height / 2, self.effectView.frame.size.width - self.effectView.frame.size.height * 3 - 5, self.effectView.frame.size.height / 2);
}

- (void)refreshModelUI{
    AVPlayerModelObj * model = [[AVPlayerQueueManager sharedManager] currentPlayingModel];
    self.modelImg.image = [UIImage imageNamed:model.model_image];
    self.playModel.text = model.model_name;
}

- (void)changeModel{
    [[AVPlayerQueueManager sharedManager] changePlayingModel];
    AVPlayerModelObj * model = [[AVPlayerQueueManager sharedManager] currentPlayingModel];
    self.modelImg.image = [UIImage imageNamed:model.model_image];
    self.playModel.text = model.model_name;
}

- (void)hideList{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideMusicListVC)]) {
        [self.delegate hideMusicListVC];
    }
}

#pragma mark - gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSString * touchClass = NSStringFromClass([touch.view class]);
    NSLog(@"dianji shoushi %@",touchClass);
    if([touchClass isEqualToString:@"AVPlayerQueueView"]){
        return true;
    }
    return false;
}

#pragma mark - table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.palyerQueueArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"palyerQueueCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    AVPlayerQueueObj * music = [self.palyerQueueArray objectAtIndex:indexPath.row];
    if(music){
        AVPlayerQueueObj * current = [[AVPlayerQueueManager sharedManager] currentPlayingMusic];
        NSInteger index = [self.palyerQueueArray indexOfObject:current];
        if(index == indexPath.row){
            cell.textLabel.textColor = orangeColor;
        }else{
            cell.textLabel.textColor = themeColor;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",music.song_name,music.song_singer];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton * delete = [[UIButton alloc] init];
        delete.frame = CGRectMake(self.frame.size.width - cell.frame.size.height * 0.75, cell.frame.size.height/4, cell.frame.size.height/2, cell.frame.size.height/2);
        [delete setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
//        delete.image = [UIImage imageNamed:@"delete.png"];
        [delete addTarget:self action:@selector(deleteFromQueue:) forControlEvents:UIControlEventTouchUpInside];
        delete.tag = indexPath.row;
//        delete.alpha = 0.7;
        [cell.contentView addSubview:delete];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVPlayerQueueObj * music = [self.palyerQueueArray objectAtIndex:indexPath.row];
    NSLog(@"55-%@",music.song_name);
    [[AVPlayerManager sharedManager] playSongWithItem:[self.palyerQueueArray objectAtIndex:indexPath.row]];
    [self.palyerQueueTable reloadData];
}

- (void)deleteFromQueue:(UIButton *)btn{
    AVPlayerQueueObj * music = [self.palyerQueueArray objectAtIndex:btn.tag];
    NSLog(@"0300-%@",music.song_name);
    [[AVPlayerQueueManager sharedManager] deleteMusic:music];
    [[AVPlayerManager sharedManager] playSongWithItem:[[AVPlayerQueueManager sharedManager] currentPlayingMusic]];
    [self.palyerQueueTable reloadData];
}

@end
