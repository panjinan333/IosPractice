//
//  AVPlayerQueueViewController.m
//  IosPractice
//
//  Created by ltl on 2019/10/21.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "AVPlayerQueueViewController.h"
#import "AVPlayerQueueView.h"

#import "Constants.h"
#import "AVPlayerManager.h"
#import "AVPlayerQueueManager.h"

@interface AVPlayerQueueViewController ()<AVPlayerQueueViewDelegate>

@end

@implementation AVPlayerQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    float top = UPPEROFFSET;
//    float scr = SCREENHEIGHT-34;
//    float tab = AUDIOPLAYTABBARHEI;
//    float main = scr - top - tab;
    AVPlayerQueueView * queueView = [[AVPlayerQueueView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    queueView.backgroundColor = [UIColor clearColor];
    queueView.delegate = self;
    [self.view addSubview:queueView];
}

#pragma mark - AVPlayerQueueViewDelegate

- (void)hideMusicListVC{
    [self dismissViewControllerAnimated:YES completion:^{
        self.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    }];
}

@end
