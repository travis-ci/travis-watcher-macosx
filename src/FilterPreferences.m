//
//  RepositoryFilter.m
//  Travis CI
//
//  Created by Henrik Hodne on 11/11/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "FilterPreferences.h"
#import "Preferences.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol Filter <NSObject>
- (BOOL)matchesSlug:(NSString *)slug;
@end

@interface AcceptAllRepositoryFilter : NSObject <Filter>
@end

@interface MatchRepositoryFilter : NSObject <Filter>

@property (strong, readonly) NSString *matcher;

- (id)initWithMatcher:(NSString *)matcher;

@end

@interface MultipleRepositoryFilter : NSObject <Filter>

- (void)addFilter:(id<Filter>)filter;

@end

@interface FilterPreferences ()
@property (nonatomic, strong) Preferences *preferences;
@property (nonatomic, strong) id<Filter> filter;
@end

@implementation FilterPreferences

+ (FilterPreferences *)filterWithPreferences:(Preferences *)preferences {
  return [[self alloc] initWithPreferences:preferences];
}

- (id)initWithPreferences:(Preferences *)preferences {
  self = [super init];
  if (self == nil) return nil;

  _preferences = preferences;
  [self setupBindings];

  return self;
}

- (void)setupBindings {
  RAC(self.filter) = [RACSignal
                      combineLatest:@[
                        RACAbleWithStart(self.preferences.firehoseEnabled),
                        RACAbleWithStart(self.preferences.repositories),
                        RACAbleWithStart(self.preferences.selfNotifications),
                        RACAbleWithStart(self.preferences.loggedInAs)
                      ]
                      reduce:^ id<Filter> (NSNumber *firehoseEnabled, NSArray *repositories, NSNumber *selfNotifications, NSString *loggedInAs) {
                        if ([firehoseEnabled boolValue]) {
                          return [AcceptAllRepositoryFilter new];
                        } else {
                          MultipleRepositoryFilter *filter = [MultipleRepositoryFilter new];

                          for (NSString *slug in repositories) {
                            [filter addFilter:[[MatchRepositoryFilter alloc] initWithMatcher:slug]];
                          }

                          if ([selfNotifications boolValue] && loggedInAs) {
                            [filter addFilter:[[MatchRepositoryFilter alloc] initWithMatcher:[NSString stringWithFormat:@"%@/*", loggedInAs]]];
                          }
                          
                          return filter;
                        }
                      }];
}

- (BOOL)matchesSlug:(NSString *)repository {
  return [[self filter] matchesSlug:repository];
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

- (void)addFilter:(id<Filter>)filter {
  [_filters addObject:filter];
}

- (BOOL)matchesSlug:(NSString *)repository {
  for (id<Filter> filter in _filters) {
    if ([filter matchesSlug:repository]) return YES;
  }

  return NO;
}

@end
