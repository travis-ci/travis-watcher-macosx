//
//  RepositoryFilter.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/11/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepositoryFilter : NSObject

+ (RepositoryFilter *)filterThatAcceptsAllRepositories;
+ (RepositoryFilter *)filterThatMatches:(NSString *)matcher;
+ (RepositoryFilter *)filtersWithMatches:(NSArray *)matches;

- (BOOL)acceptsRepository:(NSString *)repository;

@end
