//
//  Notification.m
//  Travis CI
//
//  Created by Henrik Hodne on 11/9/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "Notification.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BuildEvent.h"

@interface Notification ()

- (id)initWithEventData:(BuildEvent *)eventData;

@end

@implementation Notification

+ (Notification *)notificationWithEventData:(BuildEvent *)eventData {
  if ([eventData state] == BuildEventStateStarted) {
    return [[BuildStartedNotification alloc] initWithEventData:eventData];
  } else if ([eventData state] == BuildEventStateFinished) {
    if ([eventData status] == BuildEventStatusPassed) {
      return [[BuildPassedNotification alloc] initWithEventData:eventData];
    } else if ([eventData status] == BuildEventStatusFailed) {
      return [[BuildFailedNotification alloc] initWithEventData:eventData];
    }
  }

  return [[NullNotification alloc] initWithEventData:eventData];
}

- (id)initWithEventData:(BuildEvent *)eventData {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  _eventData = eventData;

  [self setupBindings];

  return self;
}

- (void)setupBindings {
  RAC(self.uniqueID) = RACAbleWithStart(self.eventData.buildID);
  RAC(self.title) = RACAbleWithStart(self.eventData.name);
  RAC(self.subtitle) = [RACAbleWithStart(self.eventData.buildNumber) map:^(NSNumber *buildNumber) {
    return [NSString stringWithFormat:@"Build #%@", buildNumber];
  }];
  RAC(self.URL) = RACAbleWithStart(self.eventData.url);
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