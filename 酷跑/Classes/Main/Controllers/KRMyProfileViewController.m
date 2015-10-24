//
//  KRMyProfileViewController.m
//  酷跑
//
//  Created by guoaj on 15/10/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "KRMyProfileViewController.h"
#import "KRXMPPTool.h"
#import "XMPPvCardTemp.h"
#import "KRUserInfo.h"
#import "KREditMyProfileController.h"
#import "UIImageView+KRRoundImageView.h"
@interface KRMyProfileViewController()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nikeName;

@property (strong,nonatomic) XMPPvCardTemp *vCardTemp;

@end
@implementation KRMyProfileViewController
- (void)viewDidLoad
{
    XMPPvCardTemp *vCardTemp = [KRXMPPTool sharedKRXMPPTool].xmppvCard.myvCardTemp;
    self.nikeName.text = [KRUserInfo sharedKRUserInfo].userName;
    if (vCardTemp.photo) {
        self.headImage.image = [UIImage imageWithData:vCardTemp.photo];
    }else{
        self.headImage.image = [UIImage imageNamed:@"placehoder"];
        vCardTemp.photo = UIImagePNGRepresentation(self.headImage.image);
    }
    [self.headImage setRoundLayer];
    self.vCardTemp = vCardTemp;
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navDes = segue.destinationViewController;
    if ([[navDes topViewController] isKindOfClass:[KREditMyProfileController class]]) {
        KREditMyProfileController* editProfileVc =
        (KREditMyProfileController*)[navDes topViewController];
        editProfileVc.vCardTemp = self.vCardTemp;
    }
}


@end



