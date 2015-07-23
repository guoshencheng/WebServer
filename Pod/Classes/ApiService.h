//
//  ApiService.h
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

/**
 * This is the class which handles all the API calls to server.
 *
 * Basically you first create a service instance by serviceWithDeleate:
 * then call the endpoint you want and find the callbacks in your delegate methods.
 * 
 * To make web server hold a session and relogin if session time out you may create a category Like Apiservice+Relogin.h&m to implement your relogin function, this class provide a public funtion call sendReLoginWithRequest:andLoginRequest to send relogin request
 **/

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
- (void)sendReLoginWithRequest:(ApiRequest *)apiRequest andLoginRequest:(ApiRequest *)reloginRequest;

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

- (void)service:(ApiService *)service didFailRequest:(ApiRequest *)request withError:(NSError *)error;

@end
