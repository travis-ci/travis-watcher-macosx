//
//  Notification.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/9/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Growl/Growl.h>

#import "Notification.h"

@implementation Notification

- (id)initWithTitle:(NSString *)title description:(NSString *)description {
  self = [super init];
  if (!self) {
    return nil;
  }

  _title = title;
  _description = description;

  return self;
}

- (void)deliver {
  if ([self notificationCenterIsAvailable]) {
    [self deliverWithNotificationCenter];
  } else {
    [self deliverWithGrowl];
  }
}

- (BOOL)notificationCenterIsAvailable {
  if (NSClassFromString(@"NSUserNotification")) {
    return YES;
  } else {
    return NO;
  }
}

- (void)deliverWithNotificationCenter {
  NSUserNotification *notification = [self userNotification];
  NSUserNotificationCenter *notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
  [notificationCenter deliverNotification:notification];
}

- (NSUserNotification *)userNotification {
  NSUserNotification *userNotification = [NSUserNotification new];
  userNotification.title = self.title;
  userNotification.informativeText = self.description;

  return userNotification;
}

- (void)deliverWithGrowl {
  Class GAB = NSClassFromString(@"GrowlApplicationBridge");
  if ([GAB respondsToSelector:@selector(notifyWithTitle:description:notificationName:iconData:priority:isSticky:clickContext:identifier:)])
    [GAB notifyWithTitle:self.title
             description:self.description
        notificationName:@"Build Information"
                iconData:[[NSImage imageNamed:@"travis_logo.png"] TIFFRepresentation]
                priority:0
                isSticky:NO
            clickContext:nil
              identifier:self.title];
}

@end
