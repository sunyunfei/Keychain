//
//  SYFKeyChain.m
//  Keychain存储数据
//
//  Created by 孙云 on 16/8/2.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "SYFKeyChain.h"

@implementation SYFKeyChain

+ (NSMutableDictionary *)keyChainQueryDictionaryWithService:(NSString *)service{
    
    NSMutableDictionary *keyChainQueryDictaionary = [[NSMutableDictionary alloc]init];
    [keyChainQueryDictaionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [keyChainQueryDictaionary setObject:service forKey:(id)kSecAttrService];
    [keyChainQueryDictaionary setObject:service forKey:(id)kSecAttrAccount];
    return keyChainQueryDictaionary;
}

+ (BOOL)addData:(id)data forService:(NSString *)service{
    NSMutableDictionary *keychainQuery = [self keyChainQueryDictionaryWithService:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status= SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    if (status == noErr) {
        return YES;
    }
    return NO;
}

+ (id)queryDataWithService:(NSString *)service {
    id result;
    NSMutableDictionary *keyChainQuery = [self keyChainQueryDictionaryWithService:service];
    [keyChainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keyChainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keyChainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            result = [NSKeyedUnarchiver  unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            NSLog(@"不存在数据");
        }
        @finally {
            
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return result;
}

+ (BOOL)updateData:(id)data forService:(NSString *)service{
    NSMutableDictionary *searchDictionary = [self keyChainQueryDictionaryWithService:service];
    
    if (!searchDictionary) {
        return NO;
    }
    
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    [updateDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (BOOL)deleteDataWithService:(NSString *)service{
    NSMutableDictionary *keyChainDictionary = [self keyChainQueryDictionaryWithService:service];
    OSStatus status = SecItemDelete((CFDictionaryRef)keyChainDictionary);
    if (status == noErr) {
        return YES;
    }
    return NO;
}

@end
