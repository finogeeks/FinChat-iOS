//
//  FINPushNotifacationManager.h
//  FinChat
//
//  Created by guoyong xu on 2018/8/22.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FINPushNotifacationManager : NSObject

/**
 跳转至聊天房间的代码的逻辑处理
 
 @param launchOptions app启动的时候的数据源
 @param userInfo 收到消息的信息
 */
+ (void)pushToChatRoomOptions:(NSDictionary *)launchOptions didReceiveRemoteNotification:(NSDictionary*)userInfo;
@end

