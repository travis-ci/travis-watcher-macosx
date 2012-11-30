//
//  TravisEventFetcher.h
//  Travis CI
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class RACSignal;

@interface TravisEventFetcher : NSObject
@property (readonly, strong) RACSignal *eventStream;

+ (TravisEventFetcher *)eventFetcher;
@end