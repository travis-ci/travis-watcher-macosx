//
//  TravisHTTPClient.m
//  Travis CI
//
//  Created by Henrik Hodne on 11/10/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "TravisHTTPClient.h"
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TravisKeychain.h"

NSString * const kTravisBaseURL = @"https://api.travis-ci.org";

@interface TravisHTTPClient ()
@property (nonatomic, strong) AFHTTPClient *HTTPClient;
@end

@implementation TravisHTTPClient

+ (TravisHTTPClient *)standardHTTPClient {
  return [[self alloc] initWithBaseURL:[NSURL URLWithString:kTravisBaseURL]];
}

- (id)initWithBaseURL:(NSURL *)baseURL {
  self = [super init];
  if (self == nil) return nil;

  [self setupHTTPClientWithBaseURL:baseURL];

  return self;
}

- (void)setupHTTPClientWithBaseURL:(NSURL *)baseURL {
  [self setHTTPClient:[[AFHTTPClient alloc] initWithBaseURL:baseURL]];
  [[self HTTPClient] registerHTTPOperationClass:[AFJSONRequestOperation class]];
  [[self HTTPClient] setDefaultHeader:@"Accept" value:@"application/json"];
}

- (RACSignal *)requestWithMethod:(TravisHTTPClientMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters {
  RACReplaySubject *subject = [RACReplaySubject subject];
  NSMutableURLRequest *request = [[[self HTTPClient] requestWithMethod:[self methodStringForMethod:method] path:path parameters:parameters] mutableCopy];

  if ([TravisKeychain accessToken]) {
    [request setValue:[NSString stringWithFormat:@"Token \"%@\"", [TravisKeychain accessToken]] forHTTPHeaderField:@"Authorization"];
  }

  AFHTTPRequestOperation *operation = [[self HTTPClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [subject sendNext:responseObject];
    [subject sendCompleted];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    [subject sendError:error];
  }];

  [[self HTTPClient] enqueueHTTPRequestOperation:operation];

  return subject;
}

- (NSString *)methodStringForMethod:(TravisHTTPClientMethod)method {
  switch (method) {
    case TravisHTTPClientMethodDELETE:
      return @"DELETE";
    case TravisHTTPClientMethodGET:
      return @"GET";
    case TravisHTTPClientMethodHEAD:
      return @"HEAD";
    case TravisHTTPClientMethodPATCH:
      return @"PATCH";
    case TravisHTTPClientMethodPOST:
      return @"POST";
    case TravisHTTPClientMethodPUT:
      return @"PUT";
  }
}

@end
