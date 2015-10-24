//
//  KRUserInfo.m
//  酷跑
//
//  Created by guoaj on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "KRUserInfo.h"

@implementation KRUserInfo
singleton_implementation(KRUserInfo)
/* 用户数据的沙盒读写 */
- (void) saveKRUserInfoToSandBox
{
    [[NSUserDefaults  standardUserDefaults] setValue:self.userName forKey:@"userName"];
    [[NSUserDefaults  standardUserDefaults] setValue:self.userPwd forKey:@"userPwd"];
}
- (void) loadKRUserInfoFromSandBox
{
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    self.userPwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"];
}
@end
