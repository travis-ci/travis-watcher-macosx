//
//  RepositoryFilter.m
//  Travis CI
//
//  Created by Henrik Hodne on 11/11/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "FilterPreferences.h"

@interface AcceptAllRepositoryFilter : FilterPreferences
@end

@interface MatchRepositoryFilter : FilterPreferences

@property (strong, readonly) NSString *matcher;

- (id)initWithMatcher:(NSString *)matcher;

@end

@interface MultipleRepositoryFilter : FilterPreferences

- (void)addFilter:(FilterPreferences *)filter;

@end

@implementation FilterPreferences

+ (FilterPreferences *)filterThatAcceptsAllRepositories {
  return [AcceptAllRepositoryFilter new];
}

+ (FilterPreferences *)filterThatMatches:(NSString *)matcher {
  return [[MatchRepositoryFilter alloc] initWithMatcher:matcher];
}

+ (FilterPreferences *)filtersWithMatches:(NSArray *)matches {
  MultipleRepositoryFilter *repositoryFilter = [MultipleRepositoryFilter new];

  for (NSString *matcher in matches) {
    [repositoryFilter addFilter:[FilterPreferences filterThatMatches:matcher]];
  }

  return repositoryFilter;
}

- (BOOL)matchesSlug:(NSString *)repository {
  NSAssert(NO, @"Method acceptsRepository: not implemented on %@.", self);
  return NO;
}

@end

@implementation AcceptAllRepositoryFilter

- (BOOL)matchesSlug:(NSString *)repository {
  return YES;
}

@end

@implementation MatchRepositoryFilter

- (id)initWithMatcher:(NSString *)matcher {
  self = [super init];
  if (!self) {
    return nil;
  }

  _matcher = matcher;

  return self;
}

- (BOOL)matchesSlug:(NSString *)repository {
  return [self userPartMatches:repository] && [self repositoryNamePartMatches:repository];
}

- (BOOL)userPartMatches:(NSString *)repository {
  return [self string:[self userPart:repository] matchesMatcher:[self userPart:[self matcher]]];
}

- (NSString *)userPart:(NSString *)repository {
  NSArray *repositoryParts = [repository componentsSeparatedByString:@"/"];
  return repositoryParts[0];
}

- (BOOL)repositoryNamePartMatches:(NSString *)repository {
  return [self string:[self repositoryNamePart:repository] matchesMatcher:[self repositoryNamePart:[self matcher]]];
}

- (NSString *)repositoryNamePart:(NSString *)repository {
  NSArray *repositoryParts = [repository componentsSeparatedByString:@"/"];
  return repositoryParts[1];
}

- (BOOL)string:(NSString *)string matchesMatcher:(NSString *)matcher {
  return [matcher isEqualToString:@"*"] || [matcher isEqualToString:string];
}

@end

@implementation MultipleRepositoryFilter {
  NSMutableArray *_filters;
}

- (id)init {
  self = [super init];
  if (!self) {
    return nil;
  }

  _filters = [NSMutableArray array];

  return self;
}

- (void)addFilter:(FilterPreferences *)filter {
  [_filters addObject:filter];
}

- (BOOL)matchesSlug:(NSString *)repository {
  for (FilterPreferences *filter in _filters) {
    if ([filter matchesSlug:repository]) return YES;
  }

  return NO;
}

@end
