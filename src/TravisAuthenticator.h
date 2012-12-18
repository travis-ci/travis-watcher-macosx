//
//  TravisAuthenticator.h
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface TravisAuthenticator : NSObject

+ (TravisAuthenticator *)sharedAuthenticator;

- (RACSignal *)fetchAccessTokenWithGitHubToken:(NSString *)githubToken;

@end
