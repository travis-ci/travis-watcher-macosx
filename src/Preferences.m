//
//  Preferences.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/18/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "Preferences.h"

static NSString * const kRepositoriesSetting = @"repositories";
static NSString * const kFirehoseSetting = @"firehose";
static NSString * const kFailuresOnlyNotificationsEnabled = @"failuresOnly";

@implementation Preferences

+ (Preferences *)sharedPreferences {
  static Preferences *_sharedPreferences = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedPreferences = [[Preferences alloc] init];
  });

  return _sharedPreferences;
}

- (void)setupDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults registerDefaults:@{
    kRepositoriesSetting: @[],
    kFirehoseSetting: @(NO),
  }];
}

- (NSArray *)repositories {
  NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
  return [userDefault stringArrayForKey:kRepositoriesSetting];
}

- (void)addRepository:(NSString *)slug {
  if (![[self repositories] containsObject:slug]) {
    NSArray *repositories = [[self repositories] arrayByAddingObject:slug];
    [self updateRepositories:repositories];
  }
}

- (void)removeRepository:(NSString *)slug {
  NSMutableArray *repositories = [[self repositories] mutableCopy];
  [repositories removeObject:slug];
  [self updateRepositories:repositories];
}

- (void)updateRepositories:(NSArray *)repositories {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:repositories forKey:kRepositoriesSetting];
  [userDefaults synchronize];
}

- (BOOL)firehoseEnabled {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  return [userDefaults boolForKey:kFirehoseSetting];
}

- (void)setFirehoseEnabled:(BOOL)firehoseEnabled {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:firehoseEnabled forKey:kFirehoseSetting];
  [userDefaults synchronize];
}

- (BOOL)failureOnlyNotificationEnabled {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  return [userDefaults boolForKey:kFailuresOnlyNotificationsEnabled];
}

- (void)setFailureOnlyNotificationEnabled:(BOOL)failureOnlyNotificationEnabled {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:failureOnlyNotificationEnabled forKey:kFailuresOnlyNotificationsEnabled];
  [userDefaults synchronize];
}

@end
