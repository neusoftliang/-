//
//  KRRegisterViewController.h
//  酷跑
//
//  Created by guoaj on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  KRRegisterViewControllerDelegate<NSObject>
- (void) forUserLogin;
@end
@interface KRRegisterViewController : UIViewController
@property (weak, nonatomic)  id<KRRegisterViewControllerDelegate> delegate;
@end
