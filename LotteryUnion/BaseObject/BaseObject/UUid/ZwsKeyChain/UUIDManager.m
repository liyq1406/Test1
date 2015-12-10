//
//  ZwsUserDataManager.m
//  233JuniorSchool
//
//  Created by 周文松 on 13-7-2.
//  Copyright (c) 2013年 长沙 二三三网络科技有限公司. All rights reserved.
//

#import "UUIDManager.h"
#import "GetUUID.h"

static NSString * const KEY_IN_KEYCHAIN = @"com.talkweb.www";
static NSString * const KEY_UUID = @"com.talkweb.www.uuid";

@implementation UUIDManager

+(void)saveUuid:(NSString *)uuid
{
    NSMutableDictionary *userUuidKVPairs = [NSMutableDictionary dictionary];
    [userUuidKVPairs setObject:uuid forKey:KEY_UUID];
    [GetUUID save:KEY_IN_KEYCHAIN data:userUuidKVPairs];
}

+(NSString *)readUuID
{
    NSMutableDictionary *userUuidKVPairs = (NSMutableDictionary *)[GetUUID load:KEY_IN_KEYCHAIN];
    
    if (userUuidKVPairs == nil )//如果返回的为nil，就从新存储uuid;
    {
        CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
        [self saveUuid:cfuuidString];
        CFRelease(cfuuid);
    }
    
    return [userUuidKVPairs objectForKey:KEY_UUID];//返回需要的uuid;
}
@end
