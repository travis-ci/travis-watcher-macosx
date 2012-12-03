//
//  EventConverterTests.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/1/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "EventConverter.h"
#import "BuildEvent.h"
#import "Notification.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EventConverterTests : SenTestCase
@end

@implementation EventConverterTests

- (void)testConvertsBuildStartedEvent {
  RACSubject *inputStream = [RACSubject subject];
  id<RACSubscriber> outputStream = mockProtocol(@protocol(RACSubscriber));
  EventConverter *eventConverter = [EventConverter eventConverterWithInputStream:inputStream];
  [[eventConverter outputStream] subscribe:outputStream];

  BuildEvent *event = [[BuildEvent alloc] initWithEventData:@{
    @"repository": @{ @"slug": @"travis-ci/travis-ci" },
    @"build": @{
      @"id": @(1234),
      @"number": @(15),
      @"state": @"started"
    }
  }];
  [inputStream sendNext:event];

  [verify(outputStream) sendNext:allOf(
    hasProperty(@"title", @"travis-ci/travis-ci"),
    hasProperty(@"subtitle", @"Build #15"),
    hasProperty(@"informativeText", @"Build started."),
    hasProperty(@"URL", @"http://travis-ci.org/travis-ci/travis-ci/builds/1234"),
    nil
  )];
}

@end
