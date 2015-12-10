//
//  FBSCBaseViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/12/7.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "FBSCBaseViewController.h"
#import "FBSCToolView.h"

@interface FBSCBaseViewController ()
{
    FBSCToolView *_toolView;
}
@end

@implementation FBSCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initToolBar
{
    FBTool.multiple = 1;
    _toolView = [[FBSCToolView  alloc] initWithFrame:CGRectMake(0, DeviceH - 132, DeviceW, 88) success:^{
        
        
    }];
    [self.view addSubview:_toolView];
    
    
}

- (void)gotoBetting:(NSString *)period gift_phone:(NSString *)gift_phone greetings:(NSString *)greetings
{
    NSUInteger doc = [_toolView.phoneNum.text length];
    if (!doc) {
        [SVProgressHUD showInfoWithStatus:@"请填写送彩的电话号码"];
        return;
    }

    [super gotoBetting:period gift_phone:_toolView.phoneNum.text greetings:_toolView.leaveWord.text];
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

@end
