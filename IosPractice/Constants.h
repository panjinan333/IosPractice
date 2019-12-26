//
//  Constants.h
//  IosPractice
//
//  Created by ltl on 2019/10/8.
//  Copyright © 2019 Yin. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define STATUSHEIFHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATIONHEIFHT self.navigationController.navigationBar.frame.size.height
#define UPPEROFFSET STATUSHEIFHT+NAVIGATIONHEIFHT

#define AUDIOPLAYTABBARHEI 60

//白色
#define themeColor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
//橙色
#define orangeColor [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:51.0/255.0 alpha:1.0]

#endif /* Constants_h */
