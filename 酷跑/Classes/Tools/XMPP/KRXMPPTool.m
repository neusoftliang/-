//
//  KRXMPPTool.m
//  酷跑
//
//  Created by guoaj on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "KRXMPPTool.h"
#import "KRUserInfo.h"
@interface  KRXMPPTool()<XMPPStreamDelegate>
{
    KRXMPPResultBlock _loginBlock;
    KRXMPPResultBlock _registerBlock;
}
@end
@implementation KRXMPPTool
singleton_implementation(KRXMPPTool)
/** 初始化XMPP流 */
- (void) setXmpp
{
    self.xmppStream= [[XMPPStream alloc]init];
    /* 设置代理 */
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 初始化电子名片模块 和 头像模块
    self.xmppvCardStore = [XMPPvCardCoreDataStorage sharedInstance];
    self.xmppvCard = [[XMPPvCardTempModule alloc]initWithvCardStorage:self.xmppvCardStore];
    self.xmppvCardAvtar = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:self.xmppvCard];
    // 初始化花名册模块
    _xmppRoserStore = [XMPPRosterCoreDataStorage sharedInstance];
    _xmppRoser = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRoserStore];
    // 激活花名册模块
    [self.xmppRoser activate:self.xmppStream];
    // 激活电子名片模块和头像模块
    [self.xmppvCard activate:self.xmppStream];
    [self.xmppvCardAvtar activate:self.xmppStream];
}
/** 连接服务器 */
- (void) connectHost
{
    /* 断开之前的连接 */
    [self.xmppStream disconnect];
    // 设置流相关
    [self setXmpp];
    self.xmppStream.hostName = KRXMPPHOSTNAME;
    self.xmppStream.hostPort = KRXMPPPORT;
    NSString *userName = [KRUserInfo  sharedKRUserInfo].userName;
    if ([KRUserInfo  sharedKRUserInfo].registerType) {
        userName = [KRUserInfo  sharedKRUserInfo].registerName;
    }
    XMPPJID *myJid = [XMPPJID jidWithUser:userName domain:KRXMPPDOMAIN resource:@"iphone"];
    self.xmppStream.myJID = myJid;
    NSError  *error = nil;
    [self.xmppStream  connectWithTimeout:XMPPStreamTimeoutNone
         error:&error];
    if (error) {
        MYLog(@"%@",error);
    }
}
/** 发送密码 */
- (void) sendPasswdToHost
{
    NSString *pwd = nil;
    NSError  *error = nil;
    if ([KRUserInfo  sharedKRUserInfo].registerType) {
        pwd =[KRUserInfo  sharedKRUserInfo].registerPasswd;
        [self.xmppStream registerWithPassword:pwd error:&error];
    }else{
        pwd =[KRUserInfo  sharedKRUserInfo].userPwd;
        [self.xmppStream authenticateWithPassword:pwd error:&error];
    }
    if (error) {
        MYLog(@"%@",error);
    }
}
/** 发送在线消息 */
- (void) sendOnline
{
    XMPPPresence  *persence = [XMPPPresence presence];
    [self.xmppStream sendElement:persence];
}
/** 连接成功 */
- (void) xmppStreamDidConnect:(XMPPStream *)sender
{
    MYLog(@"连接成功");
    // 服务器连接成功 发送密码
    [self sendPasswdToHost];
}
/** 断开连接  */
- (void) xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    MYLog(@"断开连接");
    if (error &&  _loginBlock) {
        _loginBlock(KRXMPPResultTypeLoginNetError);
    }
}
/** 注册成功 */
- (void) xmppStreamDidRegister:(XMPPStream *)sender
{
   MYLog(@"注册成功");
    _registerBlock(KRXMPPResultTypeRegisterSuccess);
}
/** 注册失败 */
- (void) xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
   MYLog(@"注册失败");
    _registerBlock(KRXMPPResultTypeRegisterFailure);
}
/** 授权成功 */
- (void) xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    MYLog(@"授权成功");
    _loginBlock(KRXMPPResultTypeLoginSuccess);
}
/** 授权失败 */
- (void) xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    MYLog(@"授权失败");
   _loginBlock(KRXMPPResultTypeLoginFailed);
}
/** 用户登录 */
- (void) userLogin:(KRXMPPResultBlock) block
{   
    _loginBlock = block;
    [self connectHost];
}
/** 用户注册 */
- (void) userRegister:(KRXMPPResultBlock)block
{
    _registerBlock = block;
    [self connectHost];
}
@end






