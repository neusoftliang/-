//
//  KRLoginViewController.m
//  酷跑
//
//  Created by guoaj on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "KRLoginViewController.h"
#import "KRUserInfo.h"
#import "KRXMPPTool.h"
#import "MBProgressHUD+KR.h"
#import "KRRegisterViewController.h"
@interface KRLoginViewController ()<KRRegisterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPasswd;
- (IBAction)loginBtnClick:(UIButton *)sender;

@end

@implementation KRLoginViewController
-  (void)forUserLogin
{
    self.userName.text = [KRUserInfo sharedKRUserInfo].registerName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *imageN = [UIImage imageNamed:@"icon"];
    UIImageView *leftVN = [[UIImageView alloc]initWithImage:imageN];
    leftVN.contentMode = UIViewContentModeCenter;
    leftVN.frame = CGRectMake(0, 0, 55, 20);
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    self.userName.leftView = leftVN;
    UIImage *imageP = [UIImage imageNamed:@"lock"];
    UIImageView *leftVP = [[UIImageView alloc]initWithImage:imageP];
    leftVP.contentMode = UIViewContentModeCenter;
    leftVP.frame = CGRectMake(0, 0, 55, 20);
    self.userPasswd.leftViewMode = UITextFieldViewModeAlways;
    self.userPasswd.leftView = leftVP;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginBtnClick:(UIButton *)sender {
    [KRUserInfo  sharedKRUserInfo].userName = self.userName.text;
    [KRUserInfo  sharedKRUserInfo].userPwd = self.userPasswd.text;
    if ([self.userPasswd.text isEqualToString:@"oauth2"]) {
        [MBProgressHUD  showError:@"密码不应该是oauth2"];
        return;
    }
    [KRUserInfo  sharedKRUserInfo].registerType = NO;
    [[KRXMPPTool  sharedKRXMPPTool] userLogin:^(KRXMPPResultType type) {
        [self handleResultType:type];
    }];
}
- (void) handleResultType:(KRXMPPResultType) type
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
            [MBProgressHUD showError:@"登录成功"];
            // 切换到主界面
            UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = stroyboard.instantiateInitialViewController;
            break;
        }
        default:
            break;
    }
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *vc = segue.destinationViewController;
    if ([[vc.childViewControllers lastObject] isKindOfClass:[KRRegisterViewController class]]) {
        KRRegisterViewController * desVc = (KRRegisterViewController*)vc.childViewControllers.lastObject;
        desVc.delegate = self;
    }
}

@end






