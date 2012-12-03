//
//  UserNotifier.h
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class NSUserNotificationCenter;

@interface UserNotifier : NSObject

+ (UserNotifier *)userNotifierWithInputStream:(RACSignal *)inputStream notificationCenter:(NSUserNotificationCenter *)notificationCenter;

@end
