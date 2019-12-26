//
//  LocalMusicModel.m
//  IosPractice
//
//  Created by ltl on 2019/12/23.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "LocalMusicModel.h"

@implementation LocalMusicModel

- (void)requestMPMediaLibraryAuthorizationStatus{
//    __weak typeof(self) weakSelf = self;
    MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
    if(status == MPMediaLibraryAuthorizationStatusNotDetermined){
        //用户未决定是否允许访问
        [self authorizationNotDetermined];
    }else if(status == MPMediaLibraryAuthorizationStatusDenied){
        //用户拒绝
        [self authorizationDenied];
    }else if(status == MPMediaLibraryAuthorizationStatusRestricted){
        //用户限制，部分访问
        [self authorizationRestricted];
    }else if(status == MPMediaLibraryAuthorizationStatusAuthorized){
        //用户授权允许
        [self authorizationAuthorized];
    }
}

- (void)authorizationNotDetermined{
    //弹窗询问是否开启
}

- (void)authorizationDenied{
    //提示告知未开权限
}

- (void)authorizationRestricted{
    
}

- (void)authorizationAuthorized{
    //创建媒体选择队列
    MPMediaQuery * query = [[MPMediaQuery alloc] init];
    // 创建读取条件
    MPMediaPropertyPredicate * albumNamePredicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    // 给队列添加读取条件
    [query addFilterPredicate:albumNamePredicate];
    // 从队列中获取条件的数组集合
    NSArray *itemsFromGenericQuery = [query items];
    // 遍历解析数据
    for (MPMediaItem * music in itemsFromGenericQuery) {
//        NSString *songTitle = [music valueForProperty: MPMediaItemPropertyTitle];
        //            NSString *songArtist = [music valueForProperty:MPMediaItemPropertyArtist];
        //            NSURL *url = [music valueForProperty:MPMediaItemPropertyAssetURL];
                [self resolverMediaItem:music];
    }
    
    //2.有权限，读取本地文件
    //扫描本地音乐文件，返回艺术家列表 需要库MediaPlayer.framework
    //        NSMutableArray *artistList = [[NSMutableArray alloc]init];
//            MPMediaQuery * listQuery = [MPMediaQuery playlistsQuery];//播放列表
    //        NSArray *playlist = [listQuery collections];//播放列表数组
    //        for (MPMediaPlaylist * list in playlist) {
    //            NSArray *songs = [list items];//歌曲数组
    //            for (MPMediaItem *song in songs) {
    //                NSString *title =[song valueForProperty:MPMediaItemPropertyTitle];//歌曲名
    //                //歌手名
    //                NSString *artist =[[song valueForProperty:MPMediaItemPropertyArtist] uppercaseString];
    //                if(artist!=nil&&![artistList containsObject:artist]){
    //                    [artistList addObject:artist];
    //                }
    //            }
    //        }

    
    //        [self.musicArr enumerateObjectsUsingBlock:^(MusicObject *obj, NSUInteger idx, BOOL *stop) {
    //            NSLog(@"title is %@ name is %@",obj.musicTitle,obj.musicImageName);
    //        }];
}

 // MARK:- 判断是否有权限
// - (void)requestAuthorizationForMediaLibrary {

  
// if (authStatus != MPMediaLibraryAuthorizationStatusAuthorized) {
// NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
// NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
// if (appName == nil) {
// appName = @"APP";
// }
// NSString *message = [NSString stringWithFormat:@"允许%@访问你的媒体资料库？", appName];
//
// UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:message preferredStyle:UIAlertControllerStyleAlert];
//
// UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
// [weakSelf dismissViewControllerAnimated:YES completion:nil];
// }];
//
// UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
// NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
// if ([[UIApplication sharedApplication] canOpenURL:url])
// {
// [[UIApplication sharedApplication] openURL:url];
// [weakSelf dismissViewControllerAnimated:YES completion:nil];
// }
// }];
//
// [alertController addAction:okAction];
// [alertController addAction:setAction];
//
// [self presentViewController:alertController animated:YES completion:nil];
// }
// }
// MARK:- 获取 iTunes 中的音乐
//通过创建选择队列，添加读取条件之后，我们获得了符合读取条件的数组NSArray *itemsFromGenericQuery = [query items]。但是此时itemsFromGenericQuery里面装的是一个个MPMediaItem，我们还需要对MPMediaItem处理，变成方便我们处理的Dictionary或者Model。
- (void)getItunesMusic {
    
    // 创建媒体选择队列
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    // 创建读取条件
    MPMediaPropertyPredicate *albumNamePredicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    // 给队列添加读取条件
    [query addFilterPredicate:albumNamePredicate];
    // 从队列中获取条件的数组集合
    NSArray *itemsFromGenericQuery = [query items];
    // 遍历解析数据
    for (MPMediaItem *music in itemsFromGenericQuery) {
//        [self resolverMediaItem:music];
    }
    
}
- (void)resolverMediaItem:(MPMediaItem *)music {
    
    // 歌名
    NSString *name = [music valueForProperty:MPMediaItemPropertyTitle];
    // 歌曲路径
    NSURL *fileURL = [music valueForProperty:MPMediaItemPropertyAssetURL];
    // 歌手名字
    NSString *singer = [music valueForProperty:MPMediaItemPropertyArtist];
    if(singer == nil)
    {
        singer = @"未知歌手";
    }
    // 歌曲时长（单位：秒）
    NSTimeInterval duration = [[music valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    NSString *time = @"";
    if((int)duration % 60 < 10) {
        time = [NSString stringWithFormat:@"%d:0%d",(int)duration / 60,(int)duration % 60];
    }else {
        time = [NSString stringWithFormat:@"%d:%d",(int)duration / 60,(int)duration % 60];
    }
    // 歌曲插图（没有就返回 nil）
    MPMediaItemArtwork *artwork = [music valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *image;
    if (artwork) {
        image = [artwork imageWithSize:CGSizeMake(72, 72)];
    }else {
        image = [UIImage imageNamed:@"duanshipin"];
    }
    
//    [_songArr addObject:@{@"name": name,
//                          @"fileURL": fileURL,
//                          @"singer": singer,
//                          @"time": time,
//                          @"image": image,
//                          }];
}
//歌曲路径
//   这里返回的歌曲路径直接是NSURL类型的，不是NSString类型。
//歌曲时长
//   这里查询出来的音乐的时长是以秒为单位的，也就是说如果一首歌的时长为3分钟，那这里查询出来的duration的值为180s，所以我们需要对这个值进行转换，转换成mm:ss的形式.
//歌曲封面
//   这里需要注意的是，如果歌曲没有封面，MPMediaItemArtwork为 nil，所以你需要对这个nil 单独处理下，最好是放一张默认图片。

- (void)getLocalMusic{
    NSString * source = [[NSBundle mainBundle] pathForResource:@"MusicSourceList" ofType:@"plist"];
    NSArray * arr = [[NSMutableArray alloc] initWithContentsOfFile:source];
    self.localSongListArray = [[NSMutableArray alloc] init];
    for(NSDictionary * dic in arr){
        AVPlayerQueueObj * item = [[AVPlayerQueueObj alloc] init];
        item.song_id     = [[dic objectForKey:@"songID"] integerValue];
        item.song_path   = [dic objectForKey:@"path"];
        item.song_name   = [dic objectForKey:@"name"];
        item.song_image  = [dic objectForKey:@"image"];
        item.song_singer = [dic objectForKey:@"singer"];
        [self.localSongListArray addObject:item];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"localSongDataNotification" object:nil];
  
}

@end
