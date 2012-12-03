//
//  BuildEvent.m
//  Travis CI
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "BuildEvent.h"

@interface BuildEvent ()

@property (strong) NSDictionary *eventData;

@end

@implementation BuildEvent

- (id)initWithEventData:(NSDictionary *)eventData {
  self = [super init];
  if (self) {
    _eventData = eventData;
  }

  return self;
}

- (void)updateBuildInfo:(NSDictionary *)build {
  NSMutableDictionary *eventData = [[self eventData] mutableCopy];
  eventData[@"build"] = build;
  [self setEventData:eventData];
}

- (NSString *)name {
  return [self eventData][@"repository"][@"slug"];
}

- (BuildEventStatus)status {
  NSNumber *result = [self eventData][@"build"][@"result"];
  BOOL resultIsANumber = [result isKindOfClass:[NSNumber class]];
  if (resultIsANumber && [result isEqualToNumber:@0]) {
    return BuildEventStatusPassed;
  } else if (resultIsANumber && [result isEqualToNumber:@1]) {
    return BuildEventStatusFailed;
  } else {
    return BuildEventStatusUnknown;
  }
}

- (NSNumber *)buildID {
  return [self eventData][@"build"][@"id"];
}

- (NSNumber *)buildNumber {
  return [self eventData][@"build"][@"number"];
}

- (BuildEventState)state {
  NSString *state = [self eventData][@"build"][@"state"];

  if ([state isEqualToString:@"started"]) {
    return BuildEventStateStarted;
  } else if ([state isEqualToString:@"finished"]) {
    return BuildEventStateFinished;
  } else {
    return BuildEventStateUnknown;
  }
}

- (NSString *)url {
  NSNumber *build = [self eventData][@"build"][@"id"];
  return [NSString stringWithFormat:@"http://travis-ci.org/%@/builds/%@", [self name], build];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@: %@>", [self class], [self eventData]];
}

@end
