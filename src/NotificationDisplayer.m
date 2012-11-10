//
//  NotificationManager.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/10/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "NotificationDisplayer.h"

#import "Notification.h"
#import <AppKit/AppKit.h>
#import <Growl/Growl.h>
#import "TravisEvent.h"

@implementation NotificationDisplayer

+ (NotificationDisplayer *)sharedNotificationDisplayer {
  static NotificationDisplayer *_sharedNotificationDisplayer = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedNotificationDisplayer = [NotificationDisplayer new];
  });

  return _sharedNotificationDisplayer;
}


- (void)deliverNotification:(Notification *)notification {
  if ([notification isKindOfClass:NullNotification.class]) return;

  if ([self notificationCenterIsAvailable]) {
    [self deliverWithNotificationCenter:notification];
  } else {
    [self deliverWithGrowl:notification];
  }
}

- (BOOL)notificationCenterIsAvailable {
  if (NSClassFromString(@"NSUserNotification")) {
    return YES;
  } else {
    return NO;
  }
}

- (void)deliverWithNotificationCenter:(Notification *)notification {
  NSUserNotificationCenter *notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
  for (NSUserNotification *deliveredUserNotification in notificationCenter.deliveredNotifications) {
    if ([deliveredUserNotification.userInfo[@"notificationID"] isEqualToNumber:notification.uniqueID]) {
      [notificationCenter removeDeliveredNotification:deliveredUserNotification];
    }
  }

  NSUserNotification *userNotification = [self userNotificationForNotification:notification];
  [notificationCenter deliverNotification:userNotification];
}

- (NSUserNotification *)userNotificationForNotification:(Notification *)notification {
  NSUserNotification *userNotification = [NSUserNotification new];
  userNotification.title = notification.title;
  userNotification.subtitle = notification.subtitle;
  userNotification.informativeText = notification.informativeText;
  userNotification.userInfo = @{ @"notificationID": notification.uniqueID };

  return userNotification;
}

- (void)deliverWithGrowl:(Notification *)notification {
  Class GAB = NSClassFromString(@"GrowlApplicationBridge");
  if ([GAB respondsToSelector:@selector(notifyWithTitle:description:notificationName:iconData:priority:isSticky:clickContext:identifier:)]) {
    [GAB notifyWithTitle:notification.title
             description:notification.informativeText
        notificationName:@"Build Information"
                iconData:[[NSImage imageNamed:@"travis_logo.png"] TIFFRepresentation]
                priority:0
                isSticky:NO
            clickContext:nil
              identifier:notification.uniqueID.stringValue];
  }
}

@end
