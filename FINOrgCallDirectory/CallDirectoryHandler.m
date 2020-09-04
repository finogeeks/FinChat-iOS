//
//  CallDirectoryHandler.m
//  FINOrgCallDirectory
//
//  Created by Haley on 2019/5/17.
//  Copyright © 2019 finogeeks. All rights reserved.
//

#import "CallDirectoryHandler.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;

    // Check whether this is an "incremental" data request. If so, only provide the set of phone number blocking
    // and identification entries which have been added or removed since the last time this extension's data was loaded.
    // But the extension must still be prepared to provide the full set of data at any time, so add all blocking
    // and identification phone numbers if the request is not incremental.
    [self addAllIdentificationPhoneNumbersToContext:context];
    
    [context completeRequestWithCompletionHandler:nil];
}

- (void)addAllIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    
    // Numbers must be provided in numerically ascending order.
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.finogeeks.finchat.oa"];
    if (!containerURL) {
        return;
    }
    
    containerURL = [containerURL URLByAppendingPathComponent:@"FinChatCallDirectoryData"];
    
    FILE *file = fopen([containerURL.path UTF8String], "r");
    if (!file) {
        return ;
    }
    char buffer[1024];
    
    // 一行一行的读，避免爆内存
    while (fgets(buffer, 1024, file) != NULL) {
        @autoreleasepool {
            NSString *result = [NSString stringWithUTF8String:buffer];
            NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&err];
            
            if(!err && dic && [dic isKindOfClass:[NSDictionary class]]) {
                NSString *number = dic.allKeys[0];
                NSString *name = dic[number];
                if (number && [number isKindOfClass:[NSString class]] &&
                    name && [name isKindOfClass:[NSString class]]) {
                    CXCallDirectoryPhoneNumber phoneNumber = [number longLongValue];
                    [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:name];
                }
            }
            
            dic = nil;
            result = nil;
            jsonData = nil;
            err = nil;
        }
    }
    fclose(file);
}

#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occured while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
}

@end
