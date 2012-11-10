//
//  Notification.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/9/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property (strong, readonly) NSString *title;
@property (strong, readonly) NSString *description;

- (id)initWithTitle:(NSString *)title description:(NSString *)description;

- (void)deliver;

@end
