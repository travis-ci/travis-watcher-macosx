//
//  Preferences.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/18/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

- (id)objectForKey:(NSString *)aKey;
- (void)setObject:(id)object forKey:(NSString *)aKey;

@end
