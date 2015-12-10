//
//  TelField.h
//  YaBoCaiPiaoFJ
//
//  Created by jamalping on 14-4-1.
//  Copyright (c) 2014年 DoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol passTextOfTextField <NSObject>
-(void)setTextField:(NSString *)text;
@end

@interface TelField : UITextField <UITextFieldDelegate>

@end
