//
//  TravisEvent.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  TravisEventStateStarted,
  TravisEventStateFinished,
  TravisEventStateUnknown,
} TravisEventState;

typedef enum {
  TravisEventStatusPassed,
  TravisEventStatusFailed,
  TravisEventStatusUnknown,
} TravisEventStatus;

@interface TravisEvent : NSObject

@property (readonly) NSString *name;
@property (readonly) TravisEventStatus status;
@property (readonly) NSString *url;
@property (readonly) NSNumber *buildID;
@property (readonly) NSNumber *buildNumber;
@property (readonly) TravisEventState state;

- (id)initWithEventData:(NSDictionary *)eventData;

@end
