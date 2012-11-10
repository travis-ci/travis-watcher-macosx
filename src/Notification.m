//
//  Notification.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/9/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Growl/Growl.h>

#import "Notification.h"

@implementation Notification

- (id)initWithTitle:(NSString *)title description:(NSString *)description {
  self = [super init];
  if (!self) {
    return nil;
  }

  _title = title;
  _description = description;

  return self;
}

- (void)deliver {
  Class GAB = NSClassFromString(@"GrowlApplicationBridge");
  if ([GAB respondsToSelector:@selector(notifyWithTitle:description:notificationName:iconData:priority:isSticky:clickContext:identifier:)])
    [GAB notifyWithTitle:self.title
             description:self.description
        notificationName:@"Build Information"
                iconData:[[NSImage imageNamed:@"travis_logo.png"] TIFFRepresentation]
                priority:0
                isSticky:NO
            clickContext:nil
              identifier:self.title];
}

@end
