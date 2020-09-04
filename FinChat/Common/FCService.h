//
//  FCService.h
//  FinChat
//
//  Created by 杨涛 on 2018/6/26.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface FCService : NSObject

+ (instancetype)sharedInstance;

- (void)initSession:(void (^)(void))success
         onProgress:(void (^)(void))onProgress
            failure:(void (^)(NSError *))failure;

- (BOOL)initSDK:(NSError **)aError;

- (NSString *)serverURLStr;

- (NSComparisonResult)compareFirst:(NSString *)first toSecond:(NSString *)second;

- (void)checkUpdate:(void (^)(NSDictionary *result, NSError *error))completion;

- (void)bindKeycloak:(NSString *)urlStr
               param:(NSDictionary *)param
            complete:(void (^)(NSData *data, NSURLResponse *response, NSError *error))complete;

- (void)unbindKeycloakWithCompletion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))complete;

@end
