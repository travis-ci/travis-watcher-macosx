//
//  TravisAPI.h
//  Travis CI
//
//  Created by Henrik Hodne on 11/10/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TravisHTTPClient;
@class RACSignal;

@interface TravisAPI : NSObject

+ (TravisAPI *)standardAPI;

- (id)initWithHTTPClient:(TravisHTTPClient *)HTTPClient;

- (RACSignal *)fetchBuildWithID:(NSNumber *)buildID forRepository:(NSString *)slug;
- (RACSignal *)fetchAccessTokenForGitHubToken:(NSString *)githubToken;
- (RACSignal *)fetchUserInfo;

@end
