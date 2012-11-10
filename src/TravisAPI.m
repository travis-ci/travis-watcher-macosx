//
//  TravisAPI.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/10/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "TravisAPI.h"
#import "TravisHTTPClient.h"

@implementation TravisAPI

- (void)getBuildWithID:(NSNumber *)buildID forRepository:(NSString *)slug success:(BuildResponse)success failure:(FailureResponse)failure {
  NSString *path = [NSString stringWithFormat:@"/%@/builds/%@.json", slug, buildID];

  [[TravisHTTPClient sharedHTTPClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *build) {
    if (success) success(build);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (failure) failure(error);
  }];
}

@end
