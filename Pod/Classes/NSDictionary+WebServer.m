//
//  NSDictionary+Utility.m
//  Shai
//
//  Created by guoshencheng on 7/1/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import "NSDictionary+WebServer.h"

@implementation NSDictionary (WebServer)

- (NSString *)toJsonString {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
