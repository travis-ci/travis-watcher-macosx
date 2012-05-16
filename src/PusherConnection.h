//
//  PusherConnection.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Pusher/PTPusher.h>

@interface PusherConnection : NSObject <PTPusherDelegate>

- (id)init;

@end
