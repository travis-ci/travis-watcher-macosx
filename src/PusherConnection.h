//
//  PusherConnection.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Pusher/PTPusher.h>
#import <Growl/Growl.h>

@interface PusherConnection : NSObject <PTPusherDelegate, GrowlApplicationBridgeDelegate>

- (id)init;

@end
