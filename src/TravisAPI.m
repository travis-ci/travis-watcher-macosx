//
//  TravisAPI.m
//  Travis CI
//
//  Created by Henrik Hodne on 11/10/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "TravisAPI.h"
#import "TravisHTTPClient.h"

@interface TravisAPI ()
@property (nonatomic, strong) TravisHTTPClient *HTTPClient;
@end

@implementation TravisAPI

+ (TravisAPI *)standardAPI {
  return [[self alloc] initWithHTTPClient:[TravisHTTPClient standardHTTPClient]];
}

- (id)initWithHTTPClient:(TravisHTTPClient *)HTTPClient {
  self = [super init];
  if (self == nil) return nil;

  _HTTPClient = HTTPClient;

  return self;
}

- (RACSignal *)fetchBuildWithID:(NSNumber *)buildID forRepository:(NSString *)slug {
  NSString *path = [NSString stringWithFormat:@"/repos/%@/builds/%@", slug, buildID];
  return [[self HTTPClient] requestWithMethod:TravisHTTPClientMethodGET path:path parameters:nil];
}

- (RACSignal *)fetchAccessTokenForGitHubToken:(NSString *)githubToken {
  NSParameterAssert(githubToken != nil);
  return [[self HTTPClient] requestWithMethod:TravisHTTPClientMethodPOST path:@"/auth/github" parameters:@{ @"token": githubToken }];
}

- (RACSignal *)fetchUserInfo {
  return [[self HTTPClient] requestWithMethod:TravisHTTPClientMethodGET path:@"/users/" parameters:nil];
}

@end
