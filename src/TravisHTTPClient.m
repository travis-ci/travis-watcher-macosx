//
//  TravisHTTPClient.m
//  Travis CI
//
//  Created by Henrik Hodne on 11/10/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "TravisHTTPClient.h"

NSString * const kTravisBaseURL = @"http://travis-ci.org";

@implementation TravisHTTPClient

+ (TravisHTTPClient *)sharedHTTPClient {
  static TravisHTTPClient *_sharedHTTPClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedHTTPClient = [[TravisHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kTravisBaseURL]];
  });

  return _sharedHTTPClient;
}

- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }

  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
  [self setDefaultHeader:@"Accept" value:@"application/json"];

  return self;
}

@end
