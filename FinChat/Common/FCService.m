//
//  FCService.m
//  FinChat
//
//  Created by 杨涛 on 2018/6/26.
//  Copyright © 2018年 finogeeks. All rights reserved.
//
#import <FinChatSDK/FinoChat.h>
#import "FCService.h"
#import <FinChatSDK/FINServiceFactory.h>

#import <FinChatSDK/FinoChat.h>
#import <FinChatSDK/FINRestClient.h>

#define kAppKey @"nKlvfvP/2BJrmlLB9DyWiiJU22ARzISXW6/h6Ys0sBzhFxHxCreUelTxGbAebclkBPfhZz6p+bVnYTagHouLFgPkrkkk9vob03pgAT2tTSCJJbYZ5Gri+ifdk4Ovo8xTBgySbvg/+DOI3GF76cm8JoA="

@interface FCService()
{
    
}
@property (nonatomic,assign) BOOL mayOverStup;

@end

@implementation FCService

+ (instancetype)sharedInstance {
    static FCService *_serviceFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _serviceFactory = [[self alloc] init];
    });
    return _serviceFactory;
}

- (BOOL)initSDK:(NSError **)aError
{
    [[FinoChatClient sharedInstance] setLogEnabled:NO];
    [[FinoChatClient sharedInstance] setLogToFile:NO];
    
    FinoChatOptions *options = [FinoChatOptions optionsWithConfig:[self finoChatConfig]];
    options.isAPNSRegistered = YES;
    BOOL result = [[FinoChatClient sharedInstance] fino_initSDK:options error:aError];
    
    NSString *homeserverURL = [FINServiceFactory sharedInstance].currentAccount.mxCredentials.homeServer;
    if (self.mayOverStup && (homeserverURL != nil)) {
        FinoChatConfig *config_temp = [[FinoChatConfig alloc] initWithDict:[self configDictionry:homeserverURL]];
        FinoChatOptions *options_temp = [FinoChatOptions optionsWithConfig:config_temp];
        [[FinoChatClient sharedInstance] fino_initSDK:options_temp error:aError];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:homeserverURL forKey:@"finochat_apiurl"];
        [userDefaults synchronize];
    }
    
    return result;
}

- (void) initSession: (void (^)(void))success
          onProgress:(void (^)(void))onProgress
             failure:(void (^)(NSError *))failure
{
    
    [[FinoChatClient sharedInstance] setLogEnabled:NO];
    [[FinoChatClient sharedInstance] setLogToFile:NO];
    
    
    FinoChatOptions *options = [FinoChatOptions optionsWithConfig:[self finoChatConfig]];
    options.isAPNSRegistered = YES;
    [[FinoChatClient sharedInstance] initFinoChatSession:options onProgress: onProgress success: success failure: failure];
}

- (FinoChatConfig *)finoChatConfig
{
    NSString *apiURL = @"https://api.finogeeks.club";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults stringForKey:@"finochat_apiurl"];
    if (url == nil || [url isEqualToString:@""]){
        apiURL = @"https://api.finogeeks.club";
        self.mayOverStup = YES;
    } else {
        apiURL = url;
    }
    [userDefaults setObject:apiURL forKey:@"finochat_apiurl"];
    [userDefaults synchronize];
    
    FinoChatConfig *config = [[FinoChatConfig alloc] initWithDict:[self configDictionry:apiURL]];
    return config;
}

- (NSDictionary *)configDictionry:(NSString *)apiURL {
    NSString *appKey = kAppKey;
    return @{
             @"finochatApiURL": apiURL,
             @"finochatApiPrefix" :@"/api/v1",
             @"reverseRules": @{
                     @"proxy": @"https://app.finogeeks.club"
                     },
             @"appType": @"STAFF",
             @"appGroupIdentifier":@"group.com.finogeeks.finchat.oa",
             @"callDirectoryId":@"com.finogeeks.finchat.oa.FINOrgCallDirectory",
             @"callDirectoryFileName":@"FinChatCallDirectoryData",
             @"appId":@"3",
             @"appKey": appKey,
             @"pushGatewayURL": @"http://push-service:5000/_matrix/push/v1/notify",
             @"pusherAppIdDev": @"com.finogeeks.finchat.oa",
             @"pusherAppIdProd":@"com.finogeeks.finchat.oa",
             @"appletKey": @"22LyZEib0gLTQdU3MUauAUKmAe4GJDMWBdlG9ipVB9sA",
             @"appletSecret": @"919248e19a6c7fd3",
             @"appletApiServer": @"https://finchat-mop-private.finogeeks.club",
             @"appletApiPrefix": @"/api/v1/mop",
             @"settings":@{
                     @"appConfigType":@"mobile",
                     @"isShowApplet":@(YES),
                     @"isRegistry":@(NO),
                     @"isOpenApm":@(YES),
                     @"apmUploadInterval":@(600),
                     @"isShowScanAddFriends":@(YES),
                     @"isShowGlobalFeedback":@(YES),//全局反馈
                     @"urlSchemaPrefix": @"finchat",
                     @"hideToDo": @(NO),// 待办
                     @"hideQQShare":@(NO),
                     @"hideDeviceManage": @(NO),// 设备管理
                     @"addressBook":@{
                             //@"showRecentContact":@(YES),
                             @"deleteFriend":@(YES),
                             @"labelGroup":@(YES),
                             @"disableOranaizationSort":@(YES),
                             @"disableDepartmentTap":@(NO),
                             @"autoAddFriend":@(NO),// 通讯录自动加好友
                             @"hideSearchConversation":@(NO),//是否隐藏搜索会话菜单
                             @"hideSearchMessage":@(NO),// 是否隐藏搜索消息菜单
                             @"hideSearchFile":@(YES),// 是否隐藏搜索文件菜单
                             @"hideSearchAddressBook":@(NO),//是否隐藏搜索通讯录菜单
                             @"hideSearchKnowledge":@(NO),//是否隐藏搜索知识库菜单
                             @"hideSearchCommunity":@(YES),//是否隐藏搜索合规社区菜单
                             @"hideSearchApplet":@(NO),//是否隐藏搜索小程序菜单
                             @"hideSearchChannel":@(NO),//是否隐藏搜索频道菜单
                             @"forwardToOutside":@(YES), //转发页面，消息转发到微信
                             },
                     @"chat": @{
                             @"isVideoChat":@(YES),
                             @"isVideoConference":@(YES),
                             @"isShowWaterMark":@(YES),
                             @"isScreenTaken":@(YES),
                             @"hideAddKnowledge":@(YES),
                             @"convoUIHyperTextLines": @(0),
                             @"isShowPersonCard": @(YES)  //个人名片
                             },
                     @"conversation": @{
                             @"isHideMenuItem":@(NO),
                             @"isShowGroupChat":@(YES),
                             @"isShowDirectChat":@(YES),
                             @"isShowScan":@(YES),
                             @"isShowAddChannel":@(YES),
                             @"isHideInviteRoom":@(YES),
                             @"isShowChannelWeixinAppletQR":@(NO),
                             @"isHideUnreadNum":@(NO)
                             }
                     }
             };
}

- (NSString *)serverURLStr {
    return [self finoChatConfig].finochatApiURL;
}

- (NSComparisonResult)compareFirst:(NSString *)first toSecond:(NSString *)second
{
    if (!first && !second) {
        return NSOrderedSame;
    }
    if (!first) {
        return NSOrderedAscending;
    }
    
    if (!second) {
        return NSOrderedDescending;
    }
    
    NSArray *firstList = [first componentsSeparatedByString:@"."];
    NSArray *secondList = [second componentsSeparatedByString:@"."];
    if (firstList.count > 3 || firstList.count < 2) {
        return NSOrderedAscending;
    }
    
    if (secondList.count > 3 || secondList.count < 2) {
        return NSOrderedDescending;
    }
    
    int firstNumber = 0;
    int secondNumber = 0;
    for (int i = 0; i < 2; i++) {
        firstNumber = [firstList[i] intValue];
        secondNumber = [secondList[i] intValue];
        if (firstNumber < secondNumber) {
            return NSOrderedAscending;
        }
        
        if (firstNumber > secondNumber) {
            return NSOrderedDescending;
        }
    }
    
    if (firstList.count == 2) {
        firstNumber = 0;
    } else {
        firstNumber = [firstList[2] intValue];
    }
    if (secondList.count == 2) {
        secondNumber = 0;
    } else {
        secondNumber = [secondList[2] intValue];
    }
    
    if (firstNumber < secondNumber) {
        return NSOrderedAscending;
    }
    
    if (firstNumber > secondNumber) {
        return NSOrderedDescending;
    }
    
    return NSOrderedSame;
}

- (void)checkUpdate:(void (^)(NSDictionary *result, NSError *error))completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *serverUrl = [FinoChatClient sharedInstance].options.config.finochatApiURL;
    NSString *prefix = [FinoChatClient sharedInstance].options.config.finochatApiPrefix;
    NSString *url = [NSString stringWithFormat:@"%@%@/finchat-control/updateApp/query?typeList=ios", serverUrl, prefix];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (completion) {
                    completion(nil, error);
                }
                return ;
            }
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode != 200) {
                if (completion) {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"服务器端错误"};
                    NSError *error = [NSError errorWithDomain:@"FCServiceDomain" code:-1 userInfo:userInfo];
                    completion(nil, error);
                }
                return;
            }
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (![result isKindOfClass:[NSDictionary class]]) {
                if (completion) {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"返回参数有误"};
                    NSError *error = [NSError errorWithDomain:@"FCServiceDomain" code:-1 userInfo:userInfo];
                    completion(nil, error);
                }
                return;
            }
            
            NSArray *list = [result objectForKey:@"data"];
            NSDictionary *versionInfo = list.firstObject;
            if (completion) {
                completion(versionInfo, error);
            }
        });
    }];
    [task resume];
}

- (void)bindKeycloak:(NSString *)urlStr
               param:(NSDictionary *)param
            complete:(void (^)(NSData *data, NSURLResponse *response, NSError *error))complete
{
    NSString *server = [FinoChatClient sharedInstance].options.config.finochatApiURL;
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", server, urlStr];
    NSData *data= [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    NSString *authorization = [FINRestClient sharedInstance].authorizationToken;
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", authorization] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (complete) {
            complete(data, response, error);
        }
    }];
    [task resume];
}

- (void)unbindKeycloakWithCompletion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))complete
{
    NSString *server = [FinoChatClient sharedInstance].options.config.finochatApiURL;
    NSString *path = @"/api/v1/finchat/contact/manager/staff/keycloak/unbind";
    NSString *urlString = [server stringByAppendingString:path];
    
    NSString *authorization = [FINRestClient sharedInstance].authorizationToken;
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
    request.HTTPMethod = @"POST";
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", authorization] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (complete) {
            complete(data, response, error);
        }
    }];
    [task resume];
}

@end
