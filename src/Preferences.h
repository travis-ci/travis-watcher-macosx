//
//  Preferences.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/18/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

+ (Preferences *)sharedPreferences;

- (void)setupDefaults;

- (NSArray *)repositories;
- (void)addRepository:(NSString *)slug;
- (void)removeRepository:(NSString *)slug;

- (BOOL)firehoseEnabled;
- (void)setFirehoseEnabled:(BOOL)firehoseEnabled;

- (BOOL)failureOnlyNotificationEnabled;
- (void)setFailureOnlyNotificationEnabled:(BOOL)failuresOnlyNotificationsEnabled;

@end
