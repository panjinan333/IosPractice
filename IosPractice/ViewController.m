//
//  ViewController.m
//  IosPractice
//
//  Created by ltl on 2019/10/8.
//  Copyright © 2019 Yin. All rights reserved.
//

#import "ViewController.h"
#import "FirstPageViewController.h"


//#import "AudioViewController.h"
//#import "AudioView.h"
//#import "AudioSetUpViewController.h"
//#import "Constants.h"
//#import "DYLeftSlipManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
//    [[DYLeftSlipManager sharedManager] setLeftViewController:[AudioSetUpViewController new] coverViewController:self];
    
    FirstPageViewController * page1 = [[FirstPageViewController alloc] init];
    UIViewController * page2 = [[UIViewController alloc] init];
    UIViewController * page3 = [[UIViewController alloc] init];
    UIViewController * page4 = [[UIViewController alloc] init];
    UIViewController * page5 = [[UIViewController alloc] init];
    page1.view.backgroundColor = [UIColor yellowColor];
    page2.view.backgroundColor = [UIColor redColor];
    page3.view.backgroundColor = [UIColor orangeColor];
    page4.view.backgroundColor = [UIColor purpleColor];
    
    [self setTabBarItem:page1.tabBarItem
                  title:@"1"
              titleSize:20.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"page1_2.png"
     selectedTitleColor:[UIColor blackColor]
            normalImage:@"page1_1.png"
       normalTitleColor:[UIColor blackColor]];
    page1.tabBarItem.badgeValue = @"5";
    [self setTabBarItem:page2.tabBarItem
                  title:@"2"
              titleSize:20.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"page2_2.png"
     selectedTitleColor:[UIColor blackColor]
            normalImage:@"page2_1.png"
       normalTitleColor:[UIColor blackColor]];
    [self setTabBarItem:page3.tabBarItem
                  title:@"3"
              titleSize:20.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"page3_2.png"
     selectedTitleColor:[UIColor blackColor]
            normalImage:@"page3_1.png"
       normalTitleColor:[UIColor blackColor]];
    [self setTabBarItem:page4.tabBarItem
                  title:@"4"
              titleSize:20.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"page4_2.png"
     selectedTitleColor:[UIColor blackColor]
            normalImage:@"page4_1.png"
       normalTitleColor:[UIColor blackColor]];
    
    UINavigationController * nav1 = [[UINavigationController alloc]initWithRootViewController:page1];
    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:page2];
    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:page3];
    UINavigationController * nav4 = [[UINavigationController alloc]initWithRootViewController:page4];
    UINavigationController * nav5 = [[UINavigationController alloc]initWithRootViewController:page5];
//    self.viewControllers= @[nav1,nav2,nav3,nav4];
    
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
    [self addChildViewController:nav5];
    [self addChildViewController:nav3];
    [self addChildViewController:nav4];
    
    
    UIButton * centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    centerButton.backgroundColor = [UIColor blueColor];
    [centerButton setImage:[UIImage imageNamed:@"loading.gif"] forState:UIControlStateNormal];
    [centerButton setImage:[UIImage imageNamed:@"loading.gif"] forState:UIControlStateHighlighted];
    // 设置发布按钮的frame
    // 注意的是一定要把占位的tabBarButton完全覆盖掉，不然点击的时候会把占位的子控制器点击出来
    centerButton.frame = CGRectMake(0, 0, self.tabBar.frame.size.width / 5, self.tabBar.frame.size.height);
    // 设置发布按钮的中心点，在tabBar的中心
    centerButton.center = CGPointMake(self.tabBar.frame.size.width * 0.5, self.tabBar.frame.size.height * 0.5);
    // 发布按钮的点击事件
    [centerButton addTarget:self action:@selector(centerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:centerButton];
}

- (void)centerClick{
    NSLog(@"hahahhah");
}

/**
 * 设置tabItem选项
 * @param tabbarItem tab按钮
 * @param title 标题
 * @param size 字号大小
 * @param fontName 字体
 * @param selectedImage 选中图片
 * @param selectColor 选中颜色
 * @param unselectedImage 未选中图片
 * @param unselectColor 未选中颜色
 */
- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor{
    //1.显示原图
    UIImage * selected = [UIImage imageNamed:selectedImage];
    selected = [selected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * normal = [UIImage imageNamed:unselectedImage];
    normal = [normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //
    tabbarItem = [tabbarItem initWithTitle:title image:normal selectedImage:selected];//取消系统蓝色渲染imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateSelected];
}

@end
