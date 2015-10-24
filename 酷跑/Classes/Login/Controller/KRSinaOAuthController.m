//
//  KRSinaOAuthController.m
//  酷跑
//
//  Created by guoaj on 15/10/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "KRSinaOAuthController.h"
#import "AFNetworking.h"
#import "KRUserInfo.h"
#import "KRXMPPTool.h"
#import "MBProgressHUD+KR.h"
#define  APPKEY       @"3893301452"
#define  REDIRECT_URI @"http://www.tedu.cn"
#define  APPSECRET    @"c5d9ce0901e2bcffefd10f1c0c8cd513"

@interface  KRSinaOAuthController() <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
@implementation KRSinaOAuthController
- (void) viewDidLoad
{
     NSString  *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@"
         ,APPKEY,REDIRECT_URI];
     NSURL  *url = [NSURL URLWithString:urlStr];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString  *urlPath =request.URL.absoluteString;
   
    NSRange range = [urlPath rangeOfString:[NSString stringWithFormat:@"%@%@",REDIRECT_URI,@"/?code="]];
    NSString *code = nil;
    if (range.length > 0) {
        code = [urlPath substringFromIndex:range.length];
        MYLog(@"%@",code);
        [self accesTokenWithCode:code];
        return NO;
    }
    return YES;
}
- (void) accesTokenWithCode:(NSString*) code
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager  manager];
    NSString *urlStr = @"https://api.weibo.com/oauth2/access_token";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    /*
     必选	类型及范围	说明
     client_id	true	string	申请应用时分配的AppKey。
     client_secret	true	string	申请应用时分配的AppSecret。
     grant_type	true	string	请求的类型，填写authorization_code
     
     grant_type为authorization_code时
     必选	类型及范围	说明
     code	true	string	调用authorize获得的code值。
     redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。
     */
    parameters[@"client_id"] = APPKEY;
    parameters[@"client_secret"] = APPSECRET;
    parameters[@"grant_type"] = @"authorization_code";
    parameters[@"code"] = code;
    parameters[@"redirect_uri"] = REDIRECT_URI;
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MYLog(@"获取token成功");
        /* 根据返回数据的uid生成系统内部帐号 之前生成过就使用帐号登录*/
        MYLog(@"%@",responseObject);
        NSString *innerName = [NSString stringWithFormat:@"sina%@",responseObject[@"uid"]];
        [KRUserInfo sharedKRUserInfo].registerName = innerName;
        [KRUserInfo sharedKRUserInfo].registerPasswd = @"oauth2";
        [KRUserInfo sharedKRUserInfo].userName = innerName;
        [KRUserInfo sharedKRUserInfo].userPwd = @"oauth2";
        [KRUserInfo sharedKRUserInfo].registerType = YES;
        // [];
        [[KRXMPPTool sharedKRXMPPTool] userRegister:^(KRXMPPResultType type) {
            [self handleRegisterResult:type];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MYLog(@"获取token失败");
        [self dismissViewControllerAnimated:self completion:nil];
    }];
}
/* 处理注册结果 */
-(void)  handleRegisterResult:(KRXMPPResultType) type
{
     /* 无论内部注册成功还是失败 都直接登录 */
     [KRUserInfo sharedKRUserInfo].registerType = NO;
     [[KRXMPPTool  sharedKRXMPPTool] userLogin:^(KRXMPPResultType type) {
        [self handleLoginResult:type];
     }];
}
- (void)  handleLoginResult:(KRXMPPResultType) type
{
    switch (type) {
        case KRXMPPResultTypeLoginNetError:
            [MBProgressHUD   showError:@"网路错误"];
            break;
        case KRXMPPResultTypeLoginFailed:
            [MBProgressHUD showError:@"登录失败"];
            break;
        case KRXMPPResultTypeLoginSuccess:
        {
            // [MBProgressHUD showError:@"登录成功"];
            // 切换到主界面
            UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = stroyboard.instantiateInitialViewController;
            break;
        }
        default:
            break;
    }

}
@end
