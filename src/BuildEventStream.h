//
//  BuildEventStream.h
//  Travis CI
//
//  Created by Henrik Hodne on 12/1/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface BuildEventStream : NSObject
@property (nonatomic, strong, readonly) RACSignal *eventStream;

+ (BuildEventStream *)buildEventStream;

@end
