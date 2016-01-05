//
//  AppDelegate.h
//  酷跑
//
//  Created by guoaj on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) BMKMapManager *manager;

@end

