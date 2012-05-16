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

@synthesize eventData = _eventData;

- (id)initWithEventData:(NSDictionary *)eventData {
  self = [super init];
  if (self) {
    self.eventData = eventData;
    
    //NSLog(@"%@", self.eventData);
  }
  
  return self;
}

- (NSString *)name {
  return [[self.eventData objectForKey:@"repository"] objectForKey:@"slug"];
}

- (NSString *)status {
  BOOL passed = [[self.eventData objectForKey:@"build"] objectForKey:@"result"] == 0;
  if (passed) {
    return @"passed";
  } else {
    return @"failed";
  }
}

@end
