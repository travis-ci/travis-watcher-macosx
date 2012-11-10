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
  static NotificationDisplayer *_sharedNotificationManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedNotificationManager = [NotificationDisplayer new];
  });

  return _sharedNotificationManager;
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
  NSUserNotification *userNotification = [self userNotificationForNotification:notification];
  NSUserNotificationCenter *notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
  [notificationCenter deliverNotification:userNotification];
}

- (NSUserNotification *)userNotificationForNotification:(Notification *)notification {
  NSUserNotification *userNotification = [NSUserNotification new];
  userNotification.title = notification.title;
  userNotification.informativeText = notification.informativeText;

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
              identifier:notification.eventData.buildID.stringValue];
  }
}

@end
