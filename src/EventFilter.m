//
//  EventFilter.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/1/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "EventFilter.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "BuildEvent.h"
#import "FilterPreferences.h"

@interface EventFilter ()
@property (nonatomic, strong, readonly) RACSignal *inputStream;
@property (nonatomic, strong, readonly) FilterPreferences *filterPreferences;
@end

@implementation EventFilter

- (RACSignal *)outputStream {
  @weakify(self);
  return [[self inputStream] filter:^(BuildEvent *event) {
    @strongify(self);
    return [[self filterPreferences] matchesSlug:[event name]];
  }];
}

#pragma mark - Lifecycle

+ (EventFilter *)eventFilterWithInputStream:(RACSignal *)inputStream filterPreferences:(FilterPreferences *)filterPreferences {
  return [[self alloc] initWithInputStream:inputStream filterPreferences:filterPreferences];
}

- (id)initWithInputStream:(RACSignal *)inputStream filterPreferences:(FilterPreferences *)filterPreferences {
  self = [super init];
  if (self == nil) return nil;

  _inputStream = inputStream;
  _filterPreferences = filterPreferences;

  return self;
}

@end
