//
//  Preferences.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/18/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

- (id)objectForKey:(NSString *)aKey {
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
  id object = [defs objectForKey:aKey];
  if (!object && [aKey isEqualToString:@"repositories"]) return [NSArray arrayWithObject:@"travis-ci/travis-ci"];
  else return object;
}

- (void)setObject:(id)object forKey:(NSString *)aKey {
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
  [defs setObject:object forKey:aKey];
  [defs synchronize];
}

@end
