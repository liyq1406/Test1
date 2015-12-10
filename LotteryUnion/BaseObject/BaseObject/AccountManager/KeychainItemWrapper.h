//
//  KeychainItemWrapper.h
//  TalkWeb
//
//  Created by 周文松 on 14-3-12.
//  Copyright (c) 2014年 talkweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainItemWrapper : NSObject
+ (void)write:(NSString *)service data:(id)data ;
+ (id)read:(NSString *)service;
+ (void)deleteInformation:service;
@end
