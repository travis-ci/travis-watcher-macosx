//
//  Notification.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/9/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "Notification.h"

#import "TravisEventData.h"

@interface Notification ()

- (id)initWithEventData:(TravisEventData *)eventData;

@end

@implementation Notification

+ (Notification *)notificationWithEventData:(TravisEventData *)eventData {
  if (eventData.state == TravisEventStateStarted) {
    return [[BuildStartedNotification alloc] initWithEventData:eventData];
  } else if (eventData.state == TravisEventStateFinished) {
    if (eventData.status == TravisEventStatusPassed) {
      return [[BuildPassedNotification alloc] initWithEventData:eventData];
    } else if (eventData.status == TravisEventStatusFailed) {
      return [[BuildFailedNotification alloc] initWithEventData:eventData];
    }
  }

  return [[NullNotification alloc] initWithEventData:eventData];
}

- (id)initWithEventData:(TravisEventData *)eventData {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  _eventData = eventData;

  return self;
}

- (NSString *)title {
  return [NSString stringWithFormat:@"%@ (#%@)", self.eventData.name, self.eventData.buildNumber];
}

- (NSString *)informativeText {
  NSAssert(NO, @"Method informativeText not implemented on %@", self);
  return nil;
}

@end

@implementation BuildStartedNotification

- (NSString *)informativeText {
  return @"Build started.";
}

@end

@implementation BuildPassedNotification

- (NSString *)informativeText {
  return @"Build passed.";
}

@end

@implementation BuildFailedNotification

- (NSString *)informativeText {
  return @"Build failed.";
}

@end

@implementation NullNotification
@end