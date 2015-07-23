//
//  ApiRequest.h
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ApiRequestMethodGet,
    ApiRequestMethodPost,
    ApiRequestMethodMutipartPost,
    ApiRequestMethodPut,
    ApiRequestMethodDelete
} ApiRequestMethod;

@class ApiRequest;

/**
 To create relogin request for Apiservice to relogin you should add some OwenerInfo as paramter into request
 **/
typedef void (^ConfigureRelogingRequestBlock) (ApiRequest *request);

@interface ApiRequest : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, assign) ApiRequestMethod method;
@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) NSMutableArray *paths;

/**
  create relogin request for Apiservice to relogin
 **/
+ (instancetype)requestForRelogin;

/**
 * configure function for init a relogin request
 **/
+ (void)setConfigureRelogingRequestBlock:(ConfigureRelogingRequestBlock) configureReloginRequestBlock;

@end
