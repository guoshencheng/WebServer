//
//  ApiRequest.m
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import "ApiRequest.h"

@implementation ApiRequest

static ConfigureRelogingRequestBlock _configureReloginRequestBlock;

+ (instancetype)requestForRelogin {
    ApiRequest *request = [[ApiRequest alloc] init];
    request.method = ApiRequestMethodPost;
    if (_configureReloginRequestBlock) {
        _configureReloginRequestBlock(request);
    }
    return  request;
}

@end
