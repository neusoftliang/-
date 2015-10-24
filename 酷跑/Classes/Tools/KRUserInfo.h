//
//  KRUserInfo.h
//  酷跑
//
//  Created by guoaj on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface KRUserInfo : NSObject
singleton_interface(KRUserInfo)
/* 用户的姓名和密码 */
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userPwd;
@property (assign,nonatomic) BOOL registerType;
// 用户注册信息
@property (nonatomic,copy) NSString *registerName;
@property (nonatomic,copy) NSString *registerPasswd;
@property (nonatomic,copy) NSString *jid;
/* 用户数据的沙盒读写 */
- (void) saveKRUserInfoToSandBox;
- (void) loadKRUserInfoFromSandBox;
@end
