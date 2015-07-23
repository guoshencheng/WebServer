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

/**
 * A static public function for create ApiSerice with delegate
 **/
+ (instancetype)serviceWithDelegate:(id <ApiServiceDelegate>)delegate;

/**
 * A public function for relogin and send last request
 **/
- (void)sendReLoginWithRequest:(ApiRequest *)apiRequest;

/**
 * A public function for sendRequest
 **/
- (void)sendRequest:(ApiRequest *)apiRequest;

@end

@protocol ApiServiceDelegate <NSObject>
@optional

/**
 * delegate to send message when ApiService will send Request
 **/
- (void)service:(ApiService *)service willStartRequest:(ApiRequest *)request;

/**
 * delegate to send message when ApiService had got final response
 **/
- (void)service:(ApiService *)service didFinishRequest:(ApiRequest *)request withResponse:(ApiResponse *)response;

@end
