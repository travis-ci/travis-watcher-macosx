//
//  BuildUpdater.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/1/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "BuildUpdater.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "TravisAPI.h"
#import "BuildEvent.h"

@interface BuildUpdater ()
@property (nonatomic, strong, readonly) RACSignal *inputStream;
@property (nonatomic, strong, readonly) TravisAPI *API;
@end

@implementation BuildUpdater

- (RACSignal *)outputStream {
  @weakify(self);
  return [[self inputStream] flattenMap:^(BuildEvent *event) {
    @strongify(self);
    return [[[self API] fetchBuildWithID:[event buildID] forRepository:[event name]] map:^(NSDictionary *build) {
      [event updateBuildInfo:build];
      return event;
    }];
  }];
}

+ (BuildUpdater *)buildUpdaterWithInputStream:(RACSignal *)inputStream API:(TravisAPI *)API {
  return [[self alloc] initWithInputStream:inputStream API:API];
}

- (id)initWithInputStream:(RACSignal *)inputStream API:(TravisAPI *)API {
  self = [super init];
  if (self == nil) return nil;

  _inputStream = inputStream;
  _API = API;

  return self;
}

@end
