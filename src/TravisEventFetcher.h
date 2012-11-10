//
//  TravisEventFetcher.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol TravisEventFetcherDelegate;
@class TravisEvent;

@interface TravisEventFetcher : NSObject

@property (weak) id<TravisEventFetcherDelegate> delegate;

@end

@protocol TravisEventFetcherDelegate <NSObject>

@optional
- (void)eventFetcher:(TravisEventFetcher *)eventFetcher gotEvent:(TravisEvent *)event;

@end
