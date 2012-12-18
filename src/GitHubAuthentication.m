//
//  GitHubAuthentication.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "GitHubAuthentication.h"
#import "GitHubDefines.h"

#import <AFNetworking/AFNetworking.h>
#import "TravisAPI.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TravisKeychain.h"

@interface GitHubAuthentication ()
@property (nonatomic, strong, readonly) RACReplaySubject *authenticationSubject;
@property (nonatomic, strong) RACReplaySubject *authentication;
@end

@implementation GitHubAuthentication

+ (GitHubAuthentication *)sharedAuthenticator {
  static GitHubAuthentication *_sharedAuthenticator = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedAuthenticator = [[GitHubAuthentication alloc] init];
  });

  return _sharedAuthenticator;
}

- (RACSignal *)authenticationStatus {
  return [self authenticationSubject];
}

- (id)init {
  self = [super init];
  if (self == nil) return nil;

  _authenticationSubject = [RACReplaySubject subject];

  return self;
}

- (void)signInWithBrowser {
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&scope=public_repo&response_type=code&redirect_uri=travis-ci%%3A%%2F%%2Foauth", GitHubClientID]]];
}

- (void)handleRedirect:(NSURL *)URL {
  NSString *code = [self getCodeFromURL:URL];

  NSLog(@"Our code: %@ (class: %@)", code, [code class]);

  if ([code isEqualToString:@""]) {
    NSString *error = [self getErrorFromURL:URL];
    if ([error isEqualToString:@"access_denied"]) {
      NSLog(@"Access denied");
      [[self authentication] sendError:[NSError errorWithDomain:GitHubAuthenticationErrorDomain code:GitHubAuthenticationAccessDeniedError userInfo:nil]];
    } else {
      NSLog(@"Unknown error: %@", error);
      [[self authentication] sendError:[NSError errorWithDomain:GitHubAuthenticationErrorDomain code:GitHubAuthenticationUnknownError userInfo:nil]];
    }
    
    return;
  }

  AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://github.com"]];
  [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
  [client setDefaultHeader:@"Accept" value:@"application/json"];
  [client postPath:@"/login/oauth/access_token" parameters:@{ @"client_id": GitHubClientID, @"client_secret": GitHubClientSecret, @"code": code } success:^(AFHTTPRequestOperation *operation, NSDictionary *tokenObject) {
    [[self authentication] sendNext:tokenObject[@"access_token"]];
    [[self authentication] sendCompleted];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    [[self authentication] sendError:error];
  }];
}

- (NSString *)getErrorFromURL:(NSURL *)URL {
  return [self getKey:@"error" fromURL:URL];
}

- (NSString *)getCodeFromURL:(NSURL *)URL {
  return [self getKey:@"code" fromURL:URL];
}

- (NSString *)getKey:(NSString *)key fromURL:(NSURL *)URL {
  for (NSString *component in [[URL query] componentsSeparatedByString:@"&"]) {
    NSArray *key_value = [component componentsSeparatedByString:@"="];
    NSString *thisKey = key_value[0];
    NSString *value = key_value[1];

    if ([key isEqualToString:thisKey]) return value;
  }

  return @"";
}

- (RACSignal *)fetchAccessToken {
  [self setAuthentication:[RACReplaySubject subject]];

  [self signInWithBrowser];

  return [self authentication];
}

@end

NSString * const GitHubAuthenticationErrorDomain = @"GitHubAuthenticatinoErrorDomain";