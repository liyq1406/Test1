//
//  keychainItemManager.h
//  TalkWeb
//
//  Created by 周文松 on 14-3-12.
//  Copyright (c) 2014年 talkweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@interface keychainItemManager : NSObject

+ (void)writePassWord:(NSString *)passWord;
+ (void)writePhoneNum:(NSString *)PhoneNum;
+ (void)writeSessionId:(NSString *)sessionId;
+ (void)writehasSupplyPwd:(id )hasSupplyPwd;
+ (void)writeUserID:(NSString *)userID;


+ (void)deleteSessionId;
+ (void)deletePassWord;
+ (void)deleteHasSupplyPwd;
+ (void)deleteUserId;


+(id)readPassWord;
+(id)readPhoneNum;
+(id)readSessionId;
+(id)readHasSupplyPwd;
+(id)readUserID;


@end
