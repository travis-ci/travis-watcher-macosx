//
//  BuildUpdaterTests.m
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

#import "BuildUpdater.h"
#import "BuildEvent.h"
#import "TravisAPI.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BuildUpdaterTests : SenTestCase
@end

@implementation BuildUpdaterTests {
  TravisAPI *_mockAPI;
  RACSubject *_inputStream;
  BuildUpdater *_buildUpdater;
  id<RACSubscriber> _outputStream;
}

- (void)setUp {
  _mockAPI = mock([TravisAPI class]);
  _inputStream = [RACSubject subject];
  _buildUpdater = [BuildUpdater buildUpdaterWithInputStream:_inputStream API:_mockAPI];
  
  _outputStream = mockProtocol(@protocol(RACSubscriber));
  [[_buildUpdater outputStream] subscribe:_outputStream];

  RACReplaySubject *APIResponseSubject = [RACReplaySubject subject];
  [given([_mockAPI fetchBuildWithID:@(1234) forRepository:@"travis-ci/travis-ci"]) willReturn:APIResponseSubject];
  [APIResponseSubject sendNext:@{ @"id": @(1234), @"number": @(15) }];
  [APIResponseSubject sendCompleted];
}

- (void)testBuildUpdaterUpdatesBuild {
  BuildEvent *buildEvent = [[BuildEvent alloc] initWithEventData:@{ @"build": @{ @"id": @(1234) }, @"repository": @{ @"slug": @"travis-ci/travis-ci" } }];
  [_inputStream sendNext:buildEvent];

  [verify(_outputStream) sendNext:allOf(
    hasProperty(@"buildID", @(1234)),
    hasProperty(@"buildNumber", @(15)),
    nil
  )];
}

@end
