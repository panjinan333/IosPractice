//
//  AVPlayerQueueManager.m
//  IosPractice
//
//  Created by ltl on 2019/10/14.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "AVPlayerQueueManager.h"

@implementation AVPlayerQueueManager

static NSMutableArray<AVPlayerQueueObj *> * currentMusicQueue;
static AVPlayerQueueObj * currentMusic;
static AVPlayerQueueManager * instance;
static AVPlayerModelObj * currentModel;
static NSMutableArray<AVPlayerModelObj *> * modelQueue;

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AVPlayerQueueManager alloc] init];
        
        currentMusicQueue = [[NSMutableArray alloc] init];
        modelQueue = [[NSMutableArray alloc] init];

        //播放队列
        NSMutableArray * queue = [[NSUserDefaults standardUserDefaults] objectForKey:@"AVPlayerQueue"];
        if(queue == NULL){
            NSString * source = [[NSBundle mainBundle] pathForResource:@"MusicSourceList" ofType:@"plist"];
            NSArray * arr = [[NSArray alloc] initWithContentsOfFile:source];
            for(NSDictionary * dic in arr){
                AVPlayerQueueObj * item = [[AVPlayerQueueObj alloc] init];
                item.song_id     = [[dic objectForKey:@"songID"] integerValue];
                item.song_path   = [dic objectForKey:@"path"];
                item.song_name   = [dic objectForKey:@"name"];
                item.song_image  = [dic objectForKey:@"image"];
                item.song_singer = [dic objectForKey:@"singer"];
                [currentMusicQueue addObject:item];
            }
        }else{
            currentMusicQueue = queue;
        }
        NSLog(@"播放队列-%@",currentMusicQueue);
        
        //当前播放
        AVPlayerQueueObj * current = [[NSUserDefaults standardUserDefaults] objectForKey:@"AVPlayerCurrentSong"];
        if(current == NULL){
            currentMusic = currentMusicQueue[0];
        }else{
            currentMusic = current;
        }
        
        //模式队列
        NSArray * jason = @[
                            @{
                                @"model_id"   :@"0",
                                @"model_name" :@"顺序播放",
                                @"model_type" :@"AVPlayerQueuePlayingModelSequential",
                                @"model_image":@"model-sequential"
                                },
                            @{
                                @"model_id"   :@"1",
                                @"model_name" :@"单曲播放",
                                @"model_type" :@"AVPlayerQueuePlayingModelSingle",
                                @"model_image":@"model-single"
                                },
                            @{
                                @"model_id"   :@"2",
                                @"model_name" :@"单曲循环",
                                @"model_type" :@"AVPlayerQueuePlayingModelSingleCycle",
                                @"model_image":@"model-singleCycle"
                                },
                            @{
                                @"model_id"   :@"3",
                                @"model_name" :@"随机播放",
                                @"model_type" :@"AVPlayerQueuePlayingModelRandom",
                                @"model_image":@"model-random"
                                },
                            @{
                                @"model_id"   :@"4",
                                @"model_name" :@"列表循环",
                                @"model_type" :@"AVPlayerQueuePlayingModelSequentialCycle",
                                @"model_image":@"model-sequentialCycle"
                                }
                            ];
        
        for(NSDictionary * dic in jason){
            AVPlayerModelObj * item = [[AVPlayerModelObj alloc] init];
            item.model_id    = [[dic objectForKey:@"model_id"] integerValue];
            item.model_name  = [dic objectForKey:@"model_name"];
            item.model_type  = [dic objectForKey:@"model_type"];
            item.model_image = [dic objectForKey:@"model_image"];
            [modelQueue addObject:item];
        }
        
        //播放模式
        AVPlayerModelObj * model = [[NSUserDefaults standardUserDefaults] objectForKey:@"AVPlayerCurrentModel"];
        if(model == NULL){
            currentModel = modelQueue[4];
        }else{
            currentModel = model;
        }
       
        
//        NSDictionary * defaultMusic = [arr objectAtIndex:0];
//        AVPlayerQueueObj * item = [[AVPlayerQueueObj alloc] init];
//        item.song_id = [[defaultMusic objectForKey:@"songID"] integerValue];
//        item.song_path = [defaultMusic objectForKey:@"path"];
//        item.song_name = [defaultMusic objectForKey:@"name"];
//        item.song_image = [defaultMusic objectForKey:@"image"];
//        item.song_singer = [defaultMusic objectForKey:@"singer"];
//        [currentMusicQueue addObject:item];
        
        
//        NSString * url0 = [[arr objectAtIndex:0] objectForKey:@"path"];

        
//        //沙盒
//        NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString * documentsPath = [path objectAtIndex:0];
//        NSString * plistPath = [documentsPath stringByAppendingPathComponent:@"newsTest.plist"];
//        //创建数据
//        NSMutableDictionary *newsDict = [NSMutableDictionary dictionary];
//        //赋值
//        [newsDict setObject:@"zhangsan" forKey:@"name"];
//        [newsDict setObject:@"12" forKey:@"age"];
//        [newsDict setObject:@"man" forKey:@"sex"];
//        [newsDict writeToFile:plistPath atomically:YES];
        
        NSLog(@"");
        //读取
//        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *path1 = [pathArray objectAtIndex:0];
//        NSString *myPath = [path1 stringByAppendingPathComponent:@"newsTest.plist"];
        //
        //newsModel.plist文件
//        NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
//        //newsTest.plist文件
//        NSMutableDictionary *data2 = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    });
    return instance;
}

//+ (void)initialize{
//    self->musicsQueue = [[NSMutableArray alloc] init];
//    if (_musics == nil) {
//        _musics = [ZQMusicModel objectArrayWithFilename:@"mlist.plist"];
//    }
//    if (_playingMusic == nil) {
//        _playingMusic = _musics[4];
//    }
//}
#pragma mark - 播放控制

- (NSMutableArray *)musicQueue{
    return currentMusicQueue;
}

- (AVPlayerQueueObj *)currentPlayingMusic{
    //当前播放
//    if(!currentMusicQueue){
        return currentMusic;
//    }
}

- (void)setCurrentPlayingMusic:(AVPlayerQueueObj *)item{
    //    if(!currentMusicQueue){
    currentMusic = item;
    //    }
}

// 返回上一首音乐
- (AVPlayerQueueObj *)previousMusic{
    AVPlayerModelObj * model = [self currentPlayingModel];
    if([model.model_type isEqualToString:@"AVPlayerQueuePlayingModelSequential"]){
        //顺序播放
        NSInteger index = [currentMusicQueue indexOfObject:[self currentPlayingMusic]];
        if(index > 0){
            index--;
        }
        return currentMusicQueue[index];
    }
    else if([model.model_type isEqualToString:@"AVPlayerQueuePlayingModelSingle"]){
        //单曲播放
        NSInteger index = [currentMusicQueue indexOfObject:[self currentPlayingMusic]];
        if(index == 0){
            index = currentMusicQueue.count - 1;
        }else{
            index--;
        }
        return currentMusicQueue[index];
    }
    else if([model.model_type isEqualToString:@"AVPlayerQueuePlayingModelSingleCycle"]){
        //单曲循环
        return currentMusic;
    }
    else if([model.model_type isEqualToString:@"AVPlayerQueuePlayingModelRandom"]){
        //随机播放
        NSInteger current = [currentMusicQueue indexOfObject:[self currentPlayingMusic]];
        int index = arc4random() % currentMusicQueue.count;
        while (current == index) {
            index = arc4random() % currentMusicQueue.count;
        }
        return currentMusicQueue[index];
    }
    else{
        //列表循环
        NSInteger index = [currentMusicQueue indexOfObject:[self currentPlayingMusic]];
        if(index == 0){
            index = currentMusicQueue.count - 1;
        }else{
            index--;
        }
        return currentMusicQueue[index];

    }
}
// 返回下一首音乐
- (AVPlayerQueueObj *)nextMusic{
    AVPlayerModelObj * model = [self currentPlayingModel];
    if([model.model_type isEqualToString:@"AVPlayerQueuePlayingModelSequential"]){
        //顺序播放
        NSInteger index = [currentMusicQueue indexOfObject:[self currentPlayingMusic]];
        if(index < (currentMusicQueue.count-1)){
            index++;
        }
        return currentMusicQueue[index];
    }
    else if([model.model_type isEqualToString:@"AVPlayerQueuePlayingModelSingle"]){
        //单曲播放
        NSInteger index = [currentMusicQueue indexOfObject:[self currentPlayingMusic]];
        if(index == currentMusicQueue.count - 1){
            index = 0;
        }else{
            index++;
        }
        return currentMusicQueue[index];
    }
    else if([model.model_type isEqualToString:@"AVPlayerQueuePlayingModelSingleCycle"]){
        //单曲循环
        return currentMusic;
    }
    else if([model.model_type isEqualToString:@"AVPlayerQueuePlayingModelRandom"]){
        //随机播放
        NSInteger current = [currentMusicQueue indexOfObject:[self currentPlayingMusic]];
        int index = arc4random() % currentMusicQueue.count;
        while (current == index) {
            index = arc4random() % currentMusicQueue.count;
        }
        return currentMusicQueue[index];
    }
    else{
        //列表循环
        NSInteger index = [currentMusicQueue indexOfObject:[self currentPlayingMusic]];
        if(index == currentMusicQueue.count - 1){
            index = 0;
        }else{
            index++;
        }
        return currentMusicQueue[index];
    }
}

- (void)addMusic:(AVPlayerQueueObj *)item{
    BOOL permit = true;
    for(AVPlayerQueueObj * music in currentMusicQueue){
        if(item.song_id == music.song_id){
            permit = false;
            NSLog(@"存在");
        }
    }
    if(permit){
        [currentMusicQueue addObject:item];
        NSLog(@"入队列");
    }
}

- (void)deleteMusic:(AVPlayerQueueObj *)item{
    if(item.song_id == currentMusic.song_id){
        NSLog(@"删除当前");
        currentMusic = [self nextMusic];
        [currentMusicQueue removeObject:item];
    }else{
        [currentMusicQueue removeObject:item];
    }
}

#pragma mark - 播放模式

- (AVPlayerModelObj *)currentPlayingModel{
    return currentModel;
}

- (NSMutableArray *)playingModel{
    return modelQueue;
}

- (void)changePlayingModel{
    NSInteger index = [modelQueue indexOfObject:[self currentPlayingModel]];
    //正向循环
    if(index == modelQueue.count - 1){
        index = 0;
    }else{
        index++;
    }
    currentModel = modelQueue[index];
}

/*
三、添加数据
同样是先获取路径，注意获取路径的方式视情况而定：

//用新建文件的方式常见的plist文件，获取其路径
NSString *filePath = [[NSBundle mainBundle] pathForResource:@"newsModel" ofType:@"plist"];
//代码方式创建的plist文件获取其路径
NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *path1 = [pathArray objectAtIndex:0];
NSString *myPath = [path1 stringByAppendingPathComponent:@"newsTest.plist"];

然后是取到数据：

//newsModel.plist文件
NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
//newsTest.plist文件
NSMutableDictionary *data2 = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
对数据进行操作,添加数据：

//新建一个字典，设置属性值
NSMutableDictionary *addData1 = [NSMutableDictionary dictionary];
[addData1 setObject:@"123" forKey:@"title"];
[addData1 setObject:@"pic.png" forKey:@"image"];
[addData1 setObject:@"wobushi" forKey:@"detail"];
//添加到数组中
[data1 addObject:addData1];
//写入文件
[data1 writeToFile:filePath atomically:YES];
//增加一个字段”job“，并设置属性值
[data2 setObject:@"writer" forKey:@"job"];
//写入文件
[data2 writeToFile:plistPath atomically:YES];
*/
@end
