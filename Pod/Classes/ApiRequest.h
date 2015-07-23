//
//  ApiRequest.h
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

/**
 * This is the class which saves request send to server
 *
 * When we sendRequest with Apiservice, we should create a ApiRequest first
 * the origin Class can't provide ApiRequest Create funtion, because I think it should not be managered by this class
 * To create ApiRequest wo should new a category maybe called "ApiRequest+BuildFactory.h&m" and code some method called:
 * + (instancetype)requestForUploadImageWithPath:(NSArray *)paths {
 *      ApiRequest *request = [self defaultRequest];
 *      request.method = ApiRequestMethodMutipartPost;
 *      request.url = TEST_URL;
 *      request.paths = [[NSMutableArray alloc] initWithArray:paths];
 *      request.parameters = [@{} toWebServerParameters];
 *      return  request;
 * }
 **/

#import <UIKit/UIKit.h>

typedef enum {
    ApiRequestMethodGet,
    ApiRequestMethodPost,
    ApiRequestMethodMutipartPost,
    ApiRequestMethodPut,
    ApiRequestMethodDelete
} ApiRequestMethod;

@class ApiRequest;

@interface ApiRequest : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, assign) ApiRequestMethod method;
@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) NSMutableArray *paths;

@end
