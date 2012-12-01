//
//  BuildEvent.h
//  Travis CI
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  BuildEventStateStarted,
  BuildEventStateFinished,
  BuildEventStateUnknown,
} BuildEventState;

typedef enum {
  BuildEventStatusPassed,
  BuildEventStatusFailed,
  BuildEventStatusUnknown,
} BuildEventStatus;

@interface BuildEvent : NSObject

@property (readonly) NSString *name;
@property (readonly) BuildEventStatus status;
@property (readonly) NSString *url;
@property (readonly) NSNumber *buildID;
@property (readonly) NSNumber *buildNumber;
@property (readonly) BuildEventState state;

- (id)initWithEventData:(NSDictionary *)eventData;

- (void)updateBuildInfo:(NSDictionary *)build;

@end
