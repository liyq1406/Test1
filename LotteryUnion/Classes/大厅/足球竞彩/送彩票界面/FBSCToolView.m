//
//  FBSCToolView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/12/7.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "FBSCToolView.h"
#import "SelectTelTableViewController.h"

@interface FBSCToolView ()
<passTextOfTextField>
@end

@implementation FBSCToolView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextStrokePath(context);
    [self drawRectWithLine:rect start:CGPointMake(0, 0) end:CGPointMake(CGRectGetWidth(rect), 0) lineColor:CustomBlack lineWidth:LineWidth];
}


- (id)initWithFrame:(CGRect)frame success:(void (^)())success
{
    if ((self = [super initWithFrame:frame success:success])) {
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)layoutViews
{
    [super layoutViews];
    
    [self addSubview:self.phoneNum];
    [self addSubview:self.leaveWord];
}


- (PJTextField *)phoneNum
{
    if ((!_phoneNum)) {
        _phoneNum = [[PJTextField alloc] initWithFrame:CGRectMake(0, 0, DeviceW , self.height / 2 - 5)];
        _phoneNum.leftViewMode = UITextFieldViewModeAlways;
        _phoneNum.rightViewMode = UITextFieldViewModeAlways;
        _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNum.placeholder = @"请输入对方手机号";
        _phoneNum.font = Font(14);
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DeviceW / 4, self.height / 2)];
        title.text = @"对方手机号:";
        title.font = Font(14);
        title.textAlignment = NSTextAlignmentRight;
        title.textColor = CustomBlack;
        _phoneNum.leftView = title;
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, self.height / 2, self.height / 2);
        [btn setImage:[UIImage imageNamed:@"ctzq_link_red.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(eventWithAddressbook) forControlEvents:UIControlEventTouchUpInside];
        _phoneNum.rightView = btn;
    }
    return _phoneNum;
}

- (PJTextField *)leaveWord
{
    if ((!_leaveWord)) {
        _leaveWord = [[PJTextField alloc] initWithFrame:CGRectMake(0, self.height / 2 - 5, DeviceW, self.height / 2 - 5)];
        _leaveWord.delegate = self;
        _leaveWord.returnKeyType = UIReturnKeyDone;
        _leaveWord.leftViewMode = UITextFieldViewModeAlways;
        _leaveWord.font = Font(14);
        _leaveWord.placeholder = @"请输入60字内的赠言（可不填）";
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DeviceW / 4, self.height / 2)];
        title.text = @"赠 送 留 言:";
        title.font = Font(14);
        title.textAlignment = NSTextAlignmentRight;
        title.textColor = CustomBlack;
        _leaveWord.leftView = title;
    }
    return _leaveWord;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   {
    return YES;
}

- (void)eventWithAddressbook
{
    SelectTelTableViewController *se = [[SelectTelTableViewController alloc] initWithStyle:UITableViewStylePlain];
    se.delegate = self;             // 设置代理（传电话号码）
    [[self setViewController].navigationController pushViewController:se animated:YES];
}

-(void)setTextField:(NSString *)text;
{
    _phoneNum.text = text;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
