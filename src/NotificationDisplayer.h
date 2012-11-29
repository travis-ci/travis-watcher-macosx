//
//  NotificationManager.h
//  Travis CI
//
//  Created by Henrik Hodne on 11/10/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Notification;

@interface NotificationDisplayer : NSObject

+ (NotificationDisplayer *)sharedNotificationDisplayer;

- (void)deliverNotification:(Notification *)notification;

@end
