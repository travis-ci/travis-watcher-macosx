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

@interface FilterPreferencesTests : SenTestCase
@end

@implementation FilterPreferencesTests

- (void)testFilterThatAcceptsAllRepositories {
  FilterPreferences *filter = [FilterPreferences filterThatAcceptsAllRepositories];

  assertThatBool([filter matchesSlug:@"travis-ci/travis-ci"], equalToBool(YES));
}

- (void)testFilterAcceptsExactMatch {
  FilterPreferences *filter = [FilterPreferences filterThatMatches:@"travis-ci/travis-ci"];

  assertThatBool([filter matchesSlug:@"travis-ci/travis-ci"], equalToBool(YES));
}

- (void)testFilterDoesNotAcceptWrongExactMatch {
  FilterPreferences *filter = [FilterPreferences filterThatMatches:@"travis-ci/travis-ci"];

  assertThatBool([filter matchesSlug:@"travis-ci/travis-core"], equalToBool(NO));
}

- (void)testFilterAcceptsRepositoryNameWildcard {
  FilterPreferences *filter = [FilterPreferences filterThatMatches:@"travis-ci/*"];

  assertThatBool([filter matchesSlug:@"travis-ci/travis-hub"], equalToBool(YES));
}

- (void)testFilterDoesNotAcceptWrongRepositoryNameWildcard {
  FilterPreferences *filter = [FilterPreferences filterThatMatches:@"travis-ci/*"];

  assertThatBool([filter matchesSlug:@"not-travis-ci/travic-ci"], equalToBool(NO));
}

- (void)testFilterAcceptsUserNameWildcard {
  FilterPreferences *filter = [FilterPreferences filterThatMatches:@"*/travis-ci"];

  assertThatBool([filter matchesSlug:@"john-doe/travis-ci"], equalToBool(YES));
}

- (void)testFilterThatAcceptsMultipleMatches {
  FilterPreferences *filter = [FilterPreferences filtersWithMatches:@[ @"travis-ci/travis-ci", @"travis-ci/travis-hub" ]];

  assertThatBool([filter matchesSlug:@"travis-ci/travis-ci"], equalToBool(YES));
  assertThatBool([filter matchesSlug:@"travis-ci/travis-hub"], equalToBool(YES));
}

@end
