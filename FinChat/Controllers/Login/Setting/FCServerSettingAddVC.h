//
//  FCServerSettingAddVC.h
//  FinChat
//
//  Created by xujiaqiang on 2018/11/20.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kFinchatCustomServerUrlArray;

@interface FCServerSettingAddVC : UIViewController

@property (nonatomic, strong) NSDictionary *serverInfoDict;

@property (nonatomic, strong) NSMutableArray *serverUrlArray;

#pragma mark 归档方法
//保存数据
+ (void)saveArchiveObject:(id)object name:(NSString *)name;
//取出数据
+ (id)getArchiveObjectWithName:(NSString *)name;

@end
