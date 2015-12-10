
//
//  CTFBSCBaseViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/18.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CTFBSCBaseViewController.h"
#import "CTFBModel.h"
#import "CTFBSCToolView.h"
#import "BaseBettingModel.h"

@interface CTFBSCBaseViewController ()
{
    CTFBSCToolView *_toolView;
}
@end

@implementation CTFBSCBaseViewController

- (id)init
{
    if ((self = [super init])) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}



- (UIButton *)addTitle
{
    _addTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    _addTitle.frame = CGRectMake(0, ScaleY(10), DeviceW, ScaleH(35));
    _addTitle.backgroundColor = [UIColor whiteColor];
    [_addTitle setImage:[UIImage imageNamed:@"jczq_add.png"] forState:UIControlStateNormal];
    _addTitle.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [_addTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _addTitle.titleLabel.font = Font(13);
    [_addTitle setTitle:@"多送一注" forState:UIControlStateNormal];
    [_addTitle addTarget:self action:@selector(eventWithPlayon) forControlEvents:UIControlEventTouchUpInside];
    return _addTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _table.height -= ScaleH(20);
    [_finished setTitle:@"送彩票" forState:UIControlStateNormal];
}

- (void)initToolBar
{
    CTFBTool.multiple  = 1;
    _toolView = [[CTFBSCToolView  alloc] initWithFrame:CGRectMake(0, DeviceH - 132, DeviceW, 88) success:^{
        
    }];
    [self.view addSubview:_toolView];
}

- (void)gotoBetting:(NSString *)period
{
    [SVProgressHUD showWithStatus:@"正在投注"];
    
    [BaseBettingModel gotoBettingWithCTZQ:CTFBTool.betting_results playType:_playType result:^(NSString *bettingString)
     {
         NSMutableDictionary *params = [NSMutableDictionary dictionary];
                  
         API_LotteryType lotteryType = [self getLotteryType];
         params[@"lottery_pk"] = [NSNumber numberWithInt:lotteryType];
         params[@"period"] = period;
         params[@"number"] = bettingString;
         params[@"multiple"] = [NSNumber numberWithInt:CTFBTool.multiple];
         params[@"money"] = [NSString stringWithFormat:@"%d",2 * _bettingNum * CTFBTool.multiple];
         params[@"charge_type"] = [NSNumber numberWithInteger:4];
         NSUInteger doc = [_toolView.phoneNum.text length];
         if (!doc) {
             [SVProgressHUD showInfoWithStatus:@"请填写送彩的电话号码"];
             return;
         }
         params[@"gift_phone"] = _toolView.phoneNum.text;
         params[@"greetings"] = _toolView.leaveWord.text;

         [params setPublicDomain:kAPI_BetCartAction];
         
         
         _connection = [RequestModel POST:URL(kAPI_BetCartAction) parameter:params   class:[RequestModel class]
                                  success:^(id data)
                        {
                            [SVProgressHUD dismiss];
                            [self showSuccessWithStatus:data[@"note"]];
                        }
                                  failure:^(NSString *msg, NSString *state)
                        {
                            if ([state integerValue] == Status_Code_User_Not_Login)
                            {
                                WEAKSELF
                                [self gotoLogingWithSuccess:^(BOOL isSuccess)
                                 {
                                     [weakSelf requestGotoBetting];
                                     
                                 }class:@"LoginVC"];
                                [SVProgressHUD dismiss];
                                return;
                            }
                            [SVProgressHUD showInfoWithStatus:msg];
                        }];
         
     }];
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
