//
//  GitHubAuthentication.h
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RACSignal;

typedef NS_ENUM(NSInteger, GitHubAuthenticationErrorCode) {
  GitHubAuthenticationAccessDeniedError,
  GitHubAuthenticationUnknownError,
};

@interface GitHubAuthentication : NSObject

+ (GitHubAuthentication *)sharedAuthenticator;

@property (nonatomic, strong, readonly) RACSignal *authenticationStatus;

- (void)signInWithBrowser;
- (void)handleRedirect:(NSURL *)URL;

- (RACSignal *)fetchAccessToken;

@end

FOUNDATION_EXPORT NSString * const GitHubAuthenticationErrorDomain;