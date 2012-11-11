//
//  RepositoryFilterTests.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/11/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "RepositoryFilter.h"

@interface RepositoryFilterTests : SenTestCase
@end

@implementation RepositoryFilterTests

- (void)testFilterThatAcceptsAllRepositories {
  RepositoryFilter *filter = [RepositoryFilter filterThatAcceptsAllRepositories];

  assertThatBool([filter acceptsRepository:@"travis-ci/travis-ci"], equalToBool(YES));
}

- (void)testFilterAcceptsExactMatch {
  RepositoryFilter *filter = [RepositoryFilter filterThatMatches:@"travis-ci/travis-ci"];

  assertThatBool([filter acceptsRepository:@"travis-ci/travis-ci"], equalToBool(YES));
}

- (void)testFilterDoesNotAcceptWrongExactMatch {
  RepositoryFilter *filter = [RepositoryFilter filterThatMatches:@"travis-ci/travis-ci"];

  assertThatBool([filter acceptsRepository:@"travis-ci/travis-core"], equalToBool(NO));
}

- (void)testFilterAcceptsRepositoryNameWildcard {
  RepositoryFilter *filter = [RepositoryFilter filterThatMatches:@"travis-ci/*"];

  assertThatBool([filter acceptsRepository:@"travis-ci/travis-hub"], equalToBool(YES));
}

- (void)testFilterDoesNotAcceptWrongRepositoryNameWildcard {
  RepositoryFilter *filter = [RepositoryFilter filterThatMatches:@"travis-ci/*"];

  assertThatBool([filter acceptsRepository:@"not-travis-ci/travic-ci"], equalToBool(NO));
}

- (void)testFilterAcceptsUserNameWildcard {
  RepositoryFilter *filter = [RepositoryFilter filterThatMatches:@"*/travis-ci"];

  assertThatBool([filter acceptsRepository:@"john-doe/travis-ci"], equalToBool(YES));
}

- (void)testFilterThatAcceptsMultipleMatches {
  RepositoryFilter *filter = [RepositoryFilter filtersWithMatches:@[ @"travis-ci/travis-ci", @"travis-ci/travis-hub" ]];

  assertThatBool([filter acceptsRepository:@"travis-ci/travis-ci"], equalToBool(YES));
  assertThatBool([filter acceptsRepository:@"travis-ci/travis-hub"], equalToBool(YES));
}

@end
