//
//  TravisEventData.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "TravisEventData.h"

@interface TravisEventData ()

@property (nonatomic, retain) NSDictionary *eventData;

@end

@implementation TravisEventData

@synthesize eventData = _eventData;

- (id)initWithEventData:(NSDictionary *)eventData {
  self = [super init];
  if (self) {
    self.eventData = eventData;
  }
  
  return self;
}

- (NSString *)name {
  return [[self.eventData objectForKey:@"repository"] objectForKey:@"slug"];
}

- (NSString *)status {
  NSNumber *result = [[[self.eventData objectForKey:@"build"] objectForKey:@"result"] retain];
  if ([result isEqualToNumber:[NSNumber numberWithInt:0]]) {
    [result release];
    return @"passed";
  } else {
    [result release];
    return @"failed";
  }
}

@end
