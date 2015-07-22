//
//  ApiService.h
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiRequest.h"
#import "ApiResponse.h"

@protocol ApiServiceDelegate;

@interface ApiService : NSObject

@property (nonatomic, weak) id<ApiServiceDelegate> delegate;

+ (instancetype)serviceWithDelegate:(id <ApiServiceDelegate>)delegate;
- (void)sendReLoginWithRequest:(ApiRequest *)apiRequest;
- (void)sendRequest:(ApiRequest *)apiRequest;

@end

@protocol ApiServiceDelegate <NSObject>
@optional
- (void)service:(ApiService *)service willStartRequest:(ApiRequest *)request;
- (void)service:(ApiService *)service didFinishRequest:(ApiRequest *)request withResponse:(ApiResponse *)response;

@end
