//
//  TravisAuthenticator.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "TravisAuthenticator.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TravisAPI.h"

@implementation TravisAuthenticator

+ (TravisAuthenticator *)sharedAuthenticator {
  static TravisAuthenticator *_sharedAuthenticator = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedAuthenticator = [TravisAuthenticator new];
  });

  return _sharedAuthenticator;
}

- (RACSignal *)fetchAccessTokenWithGitHubToken:(NSString *)githubToken {
  NSParameterAssert(githubToken != nil);
  return [[[TravisAPI standardAPI] fetchAccessTokenForGitHubToken:githubToken] map:^(NSDictionary *response) {
    return response[@"access_token"];
  }];
}

@end
