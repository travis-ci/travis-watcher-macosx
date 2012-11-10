//
//  Preferences.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/18/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "Preferences.h"

#define REPOSITORIES_SETTING @"repositories"

@implementation Preferences

+ (Preferences *)sharedPreferences {
  static Preferences *_sharedPreferences = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedPreferences = [[Preferences alloc] init];
  });

  return _sharedPreferences;
}

- (NSArray *)repositories {
  NSUserDefaults *userDefault = NSUserDefaults.standardUserDefaults;
  return [userDefault stringArrayForKey:REPOSITORIES_SETTING];
}

- (void)addRepository:(NSString *)slug {
  if (![self.repositories containsObject:slug]) {
    NSArray *repositories = [self.repositories arrayByAddingObject:slug];
    [self updateRepositories:repositories];
  }
}

- (void)removeRepository:(NSString *)slug {
  NSMutableArray *repositories = [self.repositories mutableCopy];
  [repositories removeObject:slug];
  [self updateRepositories:repositories];
}

- (void)updateRepositories:(NSArray *)repositories {
  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
  [userDefaults setObject:repositories forKey:REPOSITORIES_SETTING];
  [userDefaults synchronize];
}

@end
