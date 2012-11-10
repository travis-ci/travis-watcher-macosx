//
//  Notification.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/9/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TravisEvent;

@interface Notification : NSObject

@property (strong, readonly) TravisEvent *eventData;
@property (readonly) NSNumber *uniqueID;
@property (readonly) NSString *title;
@property (readonly) NSString *subtitle;
@property (readonly) NSString *informativeText;
@property (readonly) NSString *URL;

+ (Notification *)notificationWithEventData:(TravisEvent *)eventData;

@end

@interface BuildStartedNotification : Notification
@end

@interface BuildPassedNotification : Notification
@end

@interface BuildFailedNotification : Notification
@end

@interface NullNotification : Notification
@end
