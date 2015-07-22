//
//  NSDictionary+Utility.h
//  Shai
//
//  Created by guoshencheng on 7/1/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WebServer)

/**
 * Transform NSDictionary to JSonString
 **/
- (NSString *)toJsonString;

/**
 * Package self with ruled format
 **/
- (NSDictionary *)toWebServerParameters;

/**
 * assemble self
 **/
- (NSString *)assembleParameters;

@end
