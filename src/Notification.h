//
//  Notification.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/9/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TravisEventData;

@interface Notification : NSObject

@property (strong, readonly) TravisEventData *eventData;
@property (readonly) NSString *informativeText;
@property (readonly) NSString *title;

+ (Notification *)notificationWithEventData:(TravisEventData *)eventData;

@end

@interface BuildStartedNotification : Notification
@end

@interface BuildPassedNotification : Notification
@end

@interface BuildFailedNotification : Notification
@end

@interface NullNotification : Notification
@end
