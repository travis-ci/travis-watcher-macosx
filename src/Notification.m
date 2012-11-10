//
//  Notification.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/9/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

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

@end
