//
//  FirstPageViewController.m
//  IosPractice
//
//  Created by ltl on 2019/10/8.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "FirstPageViewController.h"
#import "VedioViewController.h"
#import "AudioViewController.h"
#import "Constants.h"

@interface FirstPageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSArray * array;
@property(nonatomic, strong) NSArray * viewArray;

@end

@implementation FirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.array = @[@"视频功能",@"音频功能"];
    self.viewArray = @[@"VedioViewController",@"AudioViewController"];
    
//    float tab = [UIApplication sharedApplication]
    UITableView * exampleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-NAVIGATIONHEIFHT-STATUSHEIFHT) style:UITableViewStylePlain];
    [exampleTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tablecell"];
    exampleTable.backgroundColor = [UIColor colorWithRed:180 green:200 blue:12 alpha:1.0];
    exampleTable.delegate = self;
    exampleTable.dataSource = self;
    [self.view addSubview:exampleTable];
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString * identifier = @"tablecell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class class = NSClassFromString([self.viewArray objectAtIndex:indexPath.row]);
    if(class){
        UIViewController * vc = [[class alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}

//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}

//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}

//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}

@end
