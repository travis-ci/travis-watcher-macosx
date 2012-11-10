//
//  TravisEventData.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "TravisEventData.h"

@interface TravisEventData ()

@property (strong) NSDictionary *eventData;

@end

@implementation TravisEventData

- (id)initWithEventData:(NSDictionary *)eventData {
  self = [super init];
  if (self) {
    self.eventData = eventData;
  }
  
  return self;
}

- (NSString *)name {
  return (self.eventData)[@"repository"][@"slug"];
}

- (NSString *)status {
  NSNumber *result = (self.eventData)[@"build"][@"result"];
  if ([result isEqualToNumber:@0]) {
    return @"passed";
  } else {
    return @"failed";
  }
}

- (NSString *)url {
  NSNumber *build = (self.eventData)[@"build"][@"id"];
  return [NSString stringWithFormat:@"http://travis-ci.org/%@/builds/%@", self.name, build];
}

@end
