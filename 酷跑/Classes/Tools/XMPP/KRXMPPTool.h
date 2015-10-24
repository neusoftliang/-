//
//  KRXMPPTool.h
//  酷跑
//
//  Created by guoaj on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "Singleton.h"
/* 定义XMPP 连接相关的宏 */
#define  KRXMPPDOMAIN  @"tedu.cn"
#define  KRXMPPHOSTNAME    @"127.0.0.1"
#define  KRXMPPPORT    5222
typedef enum {
    KRXMPPResultTypeLoginSuccess,
    KRXMPPResultTypeLoginFailed,
    KRXMPPResultTypeLoginNetError,
    KRXMPPResultTypeRegisterSuccess,
    KRXMPPResultTypeRegisterFailure
}KRXMPPResultType;
/* 定义BLOCK  */
typedef  void (^KRXMPPResultBlock)(KRXMPPResultType type);
@interface KRXMPPTool : NSObject
singleton_interface(KRXMPPTool)
@property (nonatomic,strong) XMPPStream *xmppStream;
/** 初始化XMPP流 */
- (void) setXmpp;
/** 连接服务器 */
- (void) connectHost;
/** 发送密码 */
- (void) sendPasswdToHost;
/** 发送在线消息 */
- (void) sendOnline;
/** 用户登录 */
- (void) userLogin:(KRXMPPResultBlock) block;
/** 用户注册 */
- (void) userRegister:(KRXMPPResultBlock)block;
@end


