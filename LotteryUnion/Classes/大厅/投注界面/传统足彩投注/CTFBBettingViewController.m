//
//  CTFBBettingViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/15.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CTFBBettingViewController.h"
#import "CTFB14ViewController.h"
#import "CTFBBettingToolView.h"
#import "DataConfigManager.h"
#import "BaseBettingModel.h"

@interface CTFBBettingCell : PJTableViewCell
@property (nonatomic) UIButton *cancel;
@end

@implementation CTFBBettingCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.font = Font(14);
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = CustomRed;
        self.detailTextLabel.font = Font(14);
        self.detailTextLabel.textColor = CustomBlack;
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancel setImage:[UIImage imageNamed:@"jczq_cut.png"] forState:UIControlStateNormal];
        self.accessoryView = _cancel;
        [self setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];

    _cancel.frame = CGRectMake(CGRectGetWidth(self.frame) - ScaleW(30), 0, ScaleW(25), CGRectGetHeight(self.frame));
}
- (void)setDatas:(id)datas
{
    self.textLabel.text = datas[@"bettingText"];
    NSString *type  = nil;
    if ([datas[@"type"] integerValue] == 1) {
        type = @"自选复式";
    }
    else
    {
        type = @"自选单式";
    }
    self.detailTextLabel.text = [[type stringByAppendingString:@"  "] stringByAppendingFormat:@"%d注%d元",[datas[@"bettingNum"] integerValue],[datas[@"bettingNum"] integerValue] * 2];
}
@end

@interface CTFBBettingViewController ()
<CTFBBettingToolViewDelegate>
@property (nonatomic, copy) void(^requestBetting)(NSString *period);
@property (nonatomic, copy) void(^requestPlayPeriod)();

@end

@implementation CTFBBettingViewController

- (void)dealloc
{
    [CTFBTool removeObserver:self forKeyPath:@"betting_results" context:NULL];
}

- (id)initWithPlayType:(CTZQPlayType)playType;
{
    if ((self = [super initWithParameters:CTFBTool.betting_results])) {
        self.hidesBottomBarWhenPushed = YES;

        _playType = playType;
        NSString *title = nil;
        switch (playType) {
            case kSF14:
                title = @"胜负14场";
                break;
            case kRX9:
                title = @"任选9场";
                break;
            case k6CBQC:
                title = @"6场半全场";
                break;
            case k4CJQ:
                title = @"4场进球";
                break;
    
            default:
                break;
        }
        [self.navigationItem setNewTitle:title];
    }
    return self;
}

- (void)removeDatas
{
    [CTFBTool.betting_results removeAllObjects];
}

- (void)eventWithPlayon
{
    NSDictionary *dic = [DataConfigManager getMainConfigList][1][@"row"][_playType];
    Class class = NSClassFromString(dic[@"viewController"]);
    UIViewController *controller = [class new];
    [self addNavigationWithPresentViewController:controller];
}

- (UILabel *)titleDate
{
    return nil;
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
    [_addTitle setTitle:@"自选一注" forState:UIControlStateNormal];
    [_addTitle addTarget:self action:@selector(eventWithPlayon) forControlEvents:UIControlEventTouchUpInside];
    return _addTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initToolBar];
    /*数组KVO*/
    [CTFBTool addObserver:self forKeyPath:@"betting_results" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self refreshViews];

    // Do any additional setup after loading the view.
}

- (void)initToolBar
{
    [CTFBBettingToolView showViewToView:self.view delegate:self];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CTFBTool.betting_results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cellIdentifer";
    CTFBBettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[CTFBBettingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
        [cell.cancel addTarget:self action:@selector(eventWithClear:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.datas = CTFBTool.betting_results[indexPath.row];
    return cell;
}

- (void)toolView:(CTFBBettingToolView *)toolView changeWithMultiple:(NSInteger)multiple
{
    [self refreshViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventWithClear:(id)sender
{
    CTFBBettingCell *cell = [UIView getView:sender toClass:@"CTFBBettingCell"];
    NSIndexPath *indexPath = [_table indexPathForCell:cell];
    /*
     删除用户当前列表对应数据
     */
    NSDictionary *dic = CTFBTool.betting_results[indexPath.row];
    [CTFBTool.betting_results removeObject:dic];
    
    /*
     刷新当前列表
     */
    [_table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    /*
     设置已添加几场比赛
     */
    [self refreshViews];
}


- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    [super viewWillAppear:animated];
}

- (void)refreshViews
{
    NSInteger bettingNum = 0;
    for (NSDictionary *dic in CTFBTool.betting_results)
    {
        bettingNum += [dic[@"bettingNum"] integerValue];
    }
    _bettingNum = bettingNum;
    [self setInfoAttributedText:[self leftText:bettingNum]];
}

- (NSMutableAttributedString *)leftText:(NSInteger)bettingNum
{
    NSString *money = [NSString stringWithFormat:@"%d",2 * bettingNum * CTFBTool.multiple];
    NSString *text = [NSString stringWithFormat:@"%d注 %d倍 共 %@ 元",bettingNum,CTFBTool.multiple, money];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attrString length])];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange([text length] - money.length - 2, [money length])];
    [attrString addAttribute:NSFontAttributeName value:Font(18) range:NSMakeRange([text length] - money.length - 2, [money length])];
    
    
    return attrString;
}

- (void)setSpendfew
{

}


#pragma mark - 数组KVO 监听，目的是知道用户在当前玩法及投注类型选择的场次
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"betting_results"])
    {
        [self reloadTabData];
        [self refreshViews];
    }
}

#pragma mark - 投注
- (void)eventWithFinish
{
    
    if (!CTFBTool.betting_results.count) {
        [SVProgressHUD showInfoWithStatus:@"请先选号投注类容"];
        return;
    }
    
    if (!UserInfoTool.isLoginedWithVirefi && !UserInfoTool.isLogined) {
        WEAKSELF
        [self gotoLogingWithSuccess:^(BOOL isSuccess)
         {
             if (isSuccess)
             {
                 [weakSelf requestGotoBetting];
             }
         }class:@"LoginVC"];
        return;
    }
    
    [self requestGotoBetting];
    
}


- (void)requestGotoBetting
{
    
    NSString *money = [NSString stringWithFormat:@"%d",2 * _bettingNum * CTFBTool.multiple];
    if ([money integerValue] > 20000) {
        [SVProgressHUD showInfoWithStatus:@"单张彩票金额超过上限20000元，请重新选择"];
        return;
    }
    else if (_bettingNum > 1000)
    {
        [SVProgressHUD showInfoWithStatus:@"单张彩票金额超过上限1000注，请重新选择"];
        return;
    }

    
    WEAKSELF
    self.requestPlayPeriod = ^{
        [weakSelf getPlayPeriod];
    };
    
    self.requestBetting = ^(NSString *period){
        weakSelf.requestBetting = nil;
        [weakSelf gotoBetting:period];
    };
    
    _requestPlayPeriod();
    self.requestPlayPeriod = nil;

    
}

- (void)getPlayPeriod
{
    [SVProgressHUD showWithStatus:@"获取期数"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    API_LotteryType lotteryType = [self getLotteryType];
    
    params[@"lottery_pk"] = [NSNumber numberWithInt:lotteryType];
    [params setPublicDomain:kAPI_QueryPlayPeriod];
    _connection = [RequestModel POST:URL(kAPI_QueryPlayPeriod) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       _requestBetting(data[@"item"][0][@"period"]);
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showInfoWithStatus:msg];
                       self.requestBetting = nil;
                   }];
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
                               [super gotoLoging];
                               [SVProgressHUD dismiss];
                               return;
                           }
                           [self showFailedWithStatus:msg];
                           [SVProgressHUD dismiss];
                       }];

    }];
}

- (void)refreshWithViews
{
    [self requestGotoBetting];
}

- (void)showSuccessWithStatus:(NSString *)msg
{
    [BettingSuccessedView showWithContent:msg returnEvent:^{
        [self removeDatas];
        [self didBack];
        
    } shareEvent:^{
        [ShareTools shareAllButtonClickHandler:@"轻轻一点，500万梦想到手。小伙伴们，快来和我一起加入体彩投注吧！" andUser:nil andUrl:APPDownloadAdrees andDes:@"快来加入彩票联盟吧~"];
        [self removeDatas];
        [self didBack];
    }];
}

- (void)showFailedWithStatus:(NSString *)msg
{
    [BettingFailedView showWithContent:msg finishedEvent:^{
        
    }];
}


#if 0
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        [self removeDatas];
        [self didBack];
    }
    else
    {
        [CTFBTool.betting_results removeAllObjects];
        [self refreshViews];
        [self reloadTabData];
        [self eventWithPlayon];
    }
}

#endif


- (API_LotteryType )getLotteryType
{
     API_LotteryType lotteryType = NSNotFound;
    switch (_playType) {
        case kSF14:
        {
            lotteryType = kType_CTZQ_SF14;
        }
            break;
        case kRX9:
        {
            lotteryType = kType_CTZQ_SF9;
        }
            
            break;
        case k6CBQC:
        {
            lotteryType = kType_CTZQ_BQC6;
        }
            break;
        case k4CJQ:
        {
            lotteryType = kType_CTZQ_JQ4;
        }
        default:
            break;
    }
    return lotteryType;
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
