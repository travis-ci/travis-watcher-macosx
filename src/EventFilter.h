//
//  EventFilter.h
//  Travis CI
//
//  Created by Henrik Hodne on 12/1/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class FilterPreferences;

@interface EventFilter : NSObject

// A stream of filtered `TravisEvent`.
@property (nonatomic, strong, readonly) RACSignal *outputStream;

// Creates a new event filter.
//
// inputStream       - A stream of `TravisEvent` objects to filter.
// filterPreferences - A `FilterPreferences` object describing how to filter the incoming `TravisEvent` objects.
+ (EventFilter *)eventFilterWithInputStream:(RACSignal *)inputStream filterPreferences:(FilterPreferences *)filterPreferences;

@end
