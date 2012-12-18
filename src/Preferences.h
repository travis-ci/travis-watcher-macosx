//
//  Preferences.h
//  Travis CI
//
//  Created by Henrik Hodne on 5/18/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

+ (Preferences *)sharedPreferences;

- (void)setupDefaults;

@property (nonatomic, readonly) NSArray *repositories;
- (void)addRepository:(NSString *)slug;
- (void)removeRepository:(NSString *)slug;

@property (nonatomic, assign) BOOL firehoseEnabled;
@property (nonatomic, assign) BOOL selfNotifications;
@property (nonatomic, strong) NSString *loggedInAs;

@end
