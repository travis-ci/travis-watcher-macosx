//
//  NotificationManager.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/10/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Notification;

@interface NotificationManager : NSObject

+ (NotificationManager *)sharedNotificationManager;

- (void)deliverNotification:(Notification *)notification;

@end
