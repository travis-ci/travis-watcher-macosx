//
//  EventConverter.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/1/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "EventConverter.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BuildEvent.h"
#import "Notification.h"

@interface EventConverter ()
@property (nonatomic, strong, readonly) RACSignal *inputStream;
@end

@implementation EventConverter

- (RACSignal *)outputStream {
  return [[self inputStream] map:^(BuildEvent *event) {
    return [Notification notificationWithEventData:event];
  }];
}

+ (EventConverter *)eventConverterWithInputStream:(RACSignal *)inputStream {
  return [[self alloc] initWithInputStream:inputStream];
}

- (id)initWithInputStream:(RACSignal *)inputStream {
  self = [super init];
  if (self == nil) return nil;

  _inputStream = inputStream;

  return self;
}

@end
