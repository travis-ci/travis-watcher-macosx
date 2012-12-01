//
//  RepositoryFilter.h
//  Travis CI
//
//  Created by Henrik Hodne on 11/11/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Preferences;

@interface FilterPreferences : NSObject

+ (FilterPreferences *)filterWithPreferences:(Preferences *)preferences;

- (BOOL)matchesSlug:(NSString *)repository;

@end
