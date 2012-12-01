//
//  RepositoryFilter.h
//  Travis CI
//
//  Created by Henrik Hodne on 11/11/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterPreferences : NSObject

+ (FilterPreferences *)filterThatAcceptsAllRepositories;
+ (FilterPreferences *)filterThatMatches:(NSString *)matcher;
+ (FilterPreferences *)filtersWithMatches:(NSArray *)matches;

- (BOOL)matchesSlug:(NSString *)repository;

@end
