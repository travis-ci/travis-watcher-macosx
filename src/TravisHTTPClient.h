//
//  TravisHTTPClient.h
//  Travis CI
//
//  Created by Henrik Hodne on 11/10/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface TravisHTTPClient : AFHTTPClient

+ (TravisHTTPClient *)sharedHTTPClient;

@end
