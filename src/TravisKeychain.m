//
//  TravisKeychain.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "TravisKeychain.h"
#import <SSKeychain/SSKeychain.h>

static NSString * const TravisKeychainService = @"org.travis-ci.toolbar";
static NSString * const TravisKeychainAccount = @"api.travis-ci.org";

@implementation TravisKeychain

+ (void)setAccessToken:(NSString *)accessToken {
  [SSKeychain setPassword:accessToken forService:TravisKeychainService account:TravisKeychainAccount];
}

+ (void)deleteAccessToken {
  [SSKeychain deletePasswordForService:TravisKeychainService account:TravisKeychainAccount];
}

+ (NSString *)accessToken {
  return [SSKeychain passwordForService:TravisKeychainService account:TravisKeychainAccount];
}

@end
