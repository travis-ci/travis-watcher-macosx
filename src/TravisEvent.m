//
//  TravisEvent.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "TravisEvent.h"

@interface TravisEvent ()

@property (strong) NSDictionary *eventData;

@end

@implementation TravisEvent

- (id)initWithEventData:(NSDictionary *)eventData {
  self = [super init];
  if (self) {
    self.eventData = eventData;
  }
  
  return self;
}

- (void)updateBuildInfo:(NSDictionary *)build {
  NSMutableDictionary *eventData = [self.eventData mutableCopy];
  eventData[@"build"] = build;
  self.eventData = eventData;
}

- (NSString *)name {
  return (self.eventData)[@"repository"][@"slug"];
}

- (TravisEventStatus)status {
  NSNumber *result = (self.eventData)[@"build"][@"result"];
  if (result && [result isEqualToNumber:@0]) {
    return TravisEventStatusPassed;
  } else if (result && [result isEqualToNumber:@1]) {
    return TravisEventStatusFailed;
  } else {
    return TravisEventStatusUnknown;
  }
}

- (NSNumber *)buildID {
  return (self.eventData)[@"build"][@"id"];
}

- (NSNumber *)buildNumber {
  return (self.eventData)[@"build"][@"number"];
}

- (TravisEventState)state {
  NSString *state = (self.eventData)[@"build"][@"state"];

  if ([state isEqualToString:@"started"]) {
    return TravisEventStateStarted;
  } else if ([state isEqualToString:@"finished"]) {
    return TravisEventStateFinished;
  } else {
    return TravisEventStateUnknown;
  }
}

- (NSString *)url {
  NSNumber *build = (self.eventData)[@"build"][@"id"];
  return [NSString stringWithFormat:@"http://travis-ci.org/%@/builds/%@", self.name, build];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@: %@>", self.class, self.eventData];
}

@end
