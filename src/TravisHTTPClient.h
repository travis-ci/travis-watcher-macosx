//
//  TravisHTTPClient.h
//  Travis CI
//
//  Created by Henrik Hodne on 11/10/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

typedef NS_ENUM(NSInteger, TravisHTTPClientMethod) {
  TravisHTTPClientMethodGET,
  TravisHTTPClientMethodHEAD,
  TravisHTTPClientMethodPOST,
  TravisHTTPClientMethodPUT,
  TravisHTTPClientMethodDELETE,
  TravisHTTPClientMethodPATCH
};

@interface TravisHTTPClient : NSObject

+ (TravisHTTPClient *)standardHTTPClient;

- (id)initWithBaseURL:(NSURL *)baseURL;

- (RACSignal *)requestWithMethod:(TravisHTTPClientMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters;

@end
