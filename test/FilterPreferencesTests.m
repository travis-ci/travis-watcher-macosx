//
//  RepositoryFilterTests.m
//  Travis CI
//
//  Created by Henrik Hodne on 11/11/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "FilterPreferences.h"
#import "Preferences.h"

@interface FakePreferences : Preferences
@property (nonatomic, assign) BOOL firehoseEnabled;
@property (nonatomic, strong) NSArray *repositories;
@end

@implementation FakePreferences
@end

@interface FilterPreferencesTests : SenTestCase
@end

@implementation FilterPreferencesTests {
  FakePreferences *_preferences;
  FilterPreferences *_filter;
}

- (void)setUp {
  _preferences = [FakePreferences new];
  [_preferences setFirehoseEnabled:NO];
  [_preferences setRepositories:@[]];
  _filter = [FilterPreferences filterWithPreferences:_preferences];
}

- (void)testFilterThatAcceptsAllRepositories {
  [_preferences setFirehoseEnabled:YES];
  assertThatBool([_filter matchesSlug:@"travis-ci/travis-ci"], equalToBool(YES));
}

- (void)testFilterAcceptsExactMatch {
  [_preferences setRepositories:@[ @"travis-ci/travis-ci" ]];
  assertThatBool([_filter matchesSlug:@"travis-ci/travis-ci"], equalToBool(YES));
}

- (void)testFilterDoesNotAcceptWrongExactMatch {
  [_preferences setRepositories:@[ @"travis-ci/travis-ci"] ];
  assertThatBool([_filter matchesSlug:@"travis-ci/travis-core"], equalToBool(NO));
}

- (void)testFilterAcceptsRepositoryNameWildcard {
  [_preferences setRepositories:@[ @"travis-ci/*" ]];
  assertThatBool([_filter matchesSlug:@"travis-ci/travis-hub"], equalToBool(YES));
}

- (void)testFilterDoesNotAcceptWrongRepositoryNameWildcard {
  [_preferences setRepositories:@[ @"travis-ci/*" ]];
  assertThatBool([_filter matchesSlug:@"not-travis-ci/travic-ci"], equalToBool(NO));
}

- (void)testFilterAcceptsUserNameWildcard {
  [_preferences setRepositories:@[ @"*/travis-ci" ]];
  assertThatBool([_filter matchesSlug:@"john-doe/travis-ci"], equalToBool(YES));
}

- (void)testFilterThatAcceptsMultipleMatches {
  [_preferences setRepositories:@[ @"travis-ci/travis-ci", @"travis-ci/travis-hub" ]];
  assertThatBool([_filter matchesSlug:@"travis-ci/travis-ci"], equalToBool(YES));
  assertThatBool([_filter matchesSlug:@"travis-ci/travis-hub"], equalToBool(YES));
}

@end
