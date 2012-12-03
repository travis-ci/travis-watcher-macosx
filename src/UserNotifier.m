//
//  UserNotifier.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "UserNotifier.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Notification.h"

@interface UserNotifier ()
@property (nonatomic, strong, readonly) RACSignal *inputStream;
@property (nonatomic, strong, readonly) NSUserNotificationCenter *notificationCenter;
@end

@implementation UserNotifier

+ (UserNotifier *)userNotifierWithInputStream:(RACSignal *)inputStream notificationCenter:(NSUserNotificationCenter *)notificationCenter {
  return [[self alloc] initWithInputStream:inputStream notificationCenter:notificationCenter];
}

- (id)initWithInputStream:(RACSignal *)inputStream notificationCenter:(NSUserNotificationCenter *)notificationCenter {
  self = [super init];
  if (self == nil) return nil;

  _inputStream = inputStream;
  _notificationCenter = notificationCenter;

  [self subscribeToInputStream];

  return self;
}

- (void)subscribeToInputStream {
  [[self inputStream] subscribeNext:^(Notification *notification) {
    [self deliverNotification:notification];
  }];
}

- (void)deliverNotification:(Notification *)notification {
  if ([notification isKindOfClass:[NullNotification class]]) return;

  [self removeOldNotificationWithID:[notification uniqueID]];

  NSUserNotification *userNotification = [self userNotificationForNotification:notification];
  [[self notificationCenter] deliverNotification:userNotification];
}

- (void)removeOldNotificationWithID:(NSNumber *)uniqueID {
  NSUserNotificationCenter *notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
  for (NSUserNotification *deliveredUserNotification in [notificationCenter deliveredNotifications]) {
    if ([[deliveredUserNotification userInfo][@"notificationID"] isEqualToNumber:uniqueID]) {
      [notificationCenter removeDeliveredNotification:deliveredUserNotification];
    }
  }
}

- (NSUserNotification *)userNotificationForNotification:(Notification *)notification {
  NSUserNotification *userNotification = [NSUserNotification new];
  [userNotification setTitle:[notification title]];
  [userNotification setSubtitle:[notification subtitle]];
  [userNotification setInformativeText:[notification informativeText]];
  [userNotification setUserInfo:@{ @"notificationID": [notification uniqueID], @"URL": [notification URL] }];

  return userNotification;
}

@end
