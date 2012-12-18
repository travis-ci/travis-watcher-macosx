//
//  TravisKeychain.h
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravisKeychain : NSObject

+ (void)setAccessToken:(NSString *)accessToken;
+ (void)deleteAccessToken;
+ (NSString *)accessToken;

@end
