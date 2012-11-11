//
//  RepositoryFilter.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/11/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "RepositoryFilter.h"

@interface AcceptAllRepositoryFilter : RepositoryFilter
@end

@interface MatchRepositoryFilter : RepositoryFilter

@property (strong, readonly) NSString *matcher;

- (id)initWithMatcher:(NSString *)matcher;

@end

@interface MultipleRepositoryFilter : RepositoryFilter

- (void)addFilter:(RepositoryFilter *)filter;

@end

@implementation RepositoryFilter

+ (RepositoryFilter *)filterThatAcceptsAllRepositories {
  return [AcceptAllRepositoryFilter new];
}

+ (RepositoryFilter *)filterThatMatches:(NSString *)matcher {
  return [[MatchRepositoryFilter alloc] initWithMatcher:matcher];
}

+ (RepositoryFilter *)filtersWithMatches:(NSArray *)matches {
  MultipleRepositoryFilter *repositoryFilter = [MultipleRepositoryFilter new];

  for (NSString *matcher in matches) {
    [repositoryFilter addFilter:[RepositoryFilter filterThatMatches:matcher]];
  }

  return repositoryFilter;
}

- (BOOL)acceptsRepository:(NSString *)repository {
  NSAssert(NO, @"Method acceptsRepository: not implemented on %@.", self);
  return NO;
}

@end

@implementation AcceptAllRepositoryFilter

- (BOOL)acceptsRepository:(NSString *)repository {
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

- (BOOL)acceptsRepository:(NSString *)repository {
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

- (void)addFilter:(RepositoryFilter *)filter {
  [_filters addObject:filter];
}

- (BOOL)acceptsRepository:(NSString *)repository {
  for (RepositoryFilter *filter in _filters) {
    if ([filter acceptsRepository:repository]) return YES;
  }

  return NO;
}

@end
