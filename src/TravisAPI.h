//
//  TravisAPI.h
//  Travis CI
//
//  Created by Henrik Hodne on 11/10/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BuildResponse)(NSDictionary *build);
typedef void (^FailureResponse)(NSError *error);

@interface TravisAPI : NSObject

- (void)getBuildWithID:(NSNumber *)buildID forRepository:(NSString *)slug success:(BuildResponse)success failure:(FailureResponse)failure;

@end
