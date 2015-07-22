//
//  ApiResponse.m
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import "ApiResponse.h"

@implementation ApiResponse

+ (instancetype)responseWithDictionary:(NSDictionary *)dictionary error:(NSError *)error {
    ApiResponse *response = [[self alloc] init];
    if (error || ![dictionary isKindOfClass:[NSDictionary class]]) {
        
    } else  {
        response.version = [[dictionary objectForKey:@"version"] floatValue];
        response.encoding = [dictionary objectForKey:@"encoding"];
        response.errorCode = [dictionary objectForKey:@"errorCode"];
        response.errorMsg = [dictionary objectForKey:@"errorMsg"];
        response.entity = [dictionary objectForKey:@"entity"];
        if (!response.entity) {
            NSDictionary *feed = [dictionary objectForKey:@"feed"];
            response.entities = [feed objectForKey:@"entities"];
        }
    }
    return response;
}

- (BOOL)success {
    return [self.errorCode integerValue] == 200;
}
- (BOOL)sessionTimeout {
    return [self.errorCode integerValue] == 4096;
}

@end
