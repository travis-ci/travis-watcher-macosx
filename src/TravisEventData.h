//
//  TravisEventData.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravisEventData : NSObject

@property (readonly) NSString *name;
@property (readonly) NSString *status;
@property (readonly) NSString *url;
@property (readonly) NSNumber *buildNumber;

- (id)initWithEventData:(NSDictionary *)eventData;

@end
