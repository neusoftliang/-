//
//  KRRegisterViewController.m
//  酷跑
//
//  Created by guoaj on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "KRRegisterViewController.h"
#import "KRXMPPTool.h"
#import "MBProgressHUD+KR.h"
#import "KRUserInfo.h"
@interface KRRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPasswd;

- (IBAction)registerBtnClick:(id)sender;

- (IBAction)cancel:(id)sender;

@end

@implementation KRRegisterViewController

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

- (IBAction)registerBtnClick:(id)sender {
    [KRUserInfo sharedKRUserInfo].registerName = self.userName.text;
    [KRUserInfo sharedKRUserInfo].registerPasswd = self.userPasswd.text;
    [KRUserInfo sharedKRUserInfo].registerType = YES;
    [[KRXMPPTool sharedKRXMPPTool] userRegister:^(KRXMPPResultType type) {
        [self handleXMPPResultType:type];
    }];
}
- (void) handleXMPPResultType:(KRXMPPResultType) type
{
    switch (type) {
        case KRXMPPResultTypeRegisterSuccess:
            [MBProgressHUD showMessage:@"注册成功"];
            if ([self.delegate  respondsToSelector:@selector(forUserLogin)]) {
                [self.delegate forUserLogin];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case KRXMPPResultTypeRegisterFailure:
            [MBProgressHUD showError:@"注册失败"];
            break;
        default:
            break;
    }
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
