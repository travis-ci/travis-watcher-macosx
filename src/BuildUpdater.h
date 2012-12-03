//
//  BuildUpdater.h
//  Travis CI
//
//  Created by Henrik Hodne on 12/1/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class TravisAPI;

@interface BuildUpdater : NSObject
@property (nonatomic, strong, readonly) RACSignal *outputStream;

+ (BuildUpdater *)buildUpdaterWithInputStream:(RACSignal *)inputStream API:(TravisAPI *)API;

@end
