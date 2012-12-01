//
//  EventFilterTests.m
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

#import "EventFilter.h"
#import "BuildEvent.h"
#import "FilterPreferences.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EventFilterTests : SenTestCase
@end

@implementation EventFilterTests {
  EventFilter *_eventFilter;
  RACSubject *_inputStream;
  FilterPreferences *_filterPreferences;
  id<RACSubscriber> _outputStream;
}

- (void)setUp {
  _inputStream = [RACSubject subject];
  _outputStream = mockProtocol(@protocol(RACSubscriber));
  _filterPreferences = mock([FilterPreferences class]);
  _eventFilter = [EventFilter eventFilterWithInputStream:_inputStream filterPreferences:_filterPreferences];
  [[_eventFilter outputStream] subscribe:_outputStream];
}

#pragma mark - Tests

- (void)testDoesNotRemoveMatchingSlugs {
  [given([_filterPreferences matchesSlug:@"travis-ci/travis-ci"]) willReturnBool:YES];

  BuildEvent *event = [[BuildEvent alloc] initWithEventData:@{ @"repository": @{ @"slug": @"travis-ci/travis-ci" } }];
  [_inputStream sendNext:event];

  [verify(_outputStream) sendNext:event];
}

- (void)testRemovesNonMatchingSlugs {
  [given([_filterPreferences matchesSlug:@"travis-ci/travis-ci"]) willReturnBool:NO];

  BuildEvent *event = [[BuildEvent alloc] initWithEventData:@{ @"repository": @{ @"slug": @"travis-ci/travis-ci" } }];
  [_inputStream sendNext:event];

  [verifyCount(_outputStream, never()) sendNext:event];
}

@end
