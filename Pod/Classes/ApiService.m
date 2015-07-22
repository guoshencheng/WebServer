//
//  ApiService.m
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import "ApiService.h"
#import "AFNetworking.h"
#import "NSDictionary+Utility.h"
#import "Owener+DataManager.h"

@interface ApiService () {
    NSOperationQueue *_requestQueue;
}

@end

@implementation ApiService

#pragma mark - Object Lifecycle

- (id)init {
    if (self = [super init]) {
        _requestQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

+ (instancetype)serviceWithDelegate:(id<ApiServiceDelegate>)delegate {
    ApiService *service = [[self alloc] init];
    service.delegate = delegate;
    return service;
}

- (void)sendReLoginWithRequest:(ApiRequest *)apiRequest {
    Owener *owner = [Owener getOwenserInfomation];
    [self sendPostRequest:[ApiRequest requestForLoginWithUserId:[owner.userId stringValue] nickName:owner.nickName avatarUrl:owner.avatarUrl] withCompletion:^(id data, NSError *error) {
        ApiResponse *apiResponse = [ApiResponse postResponseWithDictionary:data error:error];
        if ([apiResponse success]) {
            [self sendRequest:apiRequest];
        }
    }];
}

- (void)sendRequest:(ApiRequest *)apiRequest {
    [self sendRequest:apiRequest withCompletion:^(id dictionary, NSError *error) {
        ApiResponse *apiResponse;
        if (apiRequest.method == ApiRequestMethodGet) {
            apiResponse = [ApiResponse getResponseWithDictionary:dictionary error:error];
        } else {
            apiResponse = [ApiResponse postResponseWithDictionary:dictionary error:error];
        }
        if ([apiResponse sessionTimeout]) {
            [self sendReLoginWithRequest:apiRequest];
        } else {
            if ([self.delegate respondsToSelector:@selector(service:didFinishRequest:withResponse:)]) {
                [self.delegate service:self didFinishRequest:apiRequest withResponse:apiResponse];
            }
        }
        NSLog(@"%@",dictionary);
    }];
}

#pragma mark - Private Methods

- (void)sendRequest:(ApiRequest *)apiRequest withCompletion:(void (^)(id dictionary, NSError *error))completion {
    if ([self.delegate respondsToSelector:@selector(service:willStartRequest:)]) {
        [self.delegate service:self willStartRequest:apiRequest];
    }
    switch (apiRequest.method) {
        case ApiRequestMethodGet:
            [self sendGetRequest:apiRequest withCompletion:completion];
            break;
        case ApiRequestMethodPost:
            [self sendPostRequest:apiRequest withCompletion:completion];
            break;
        case ApiRequestMethodMutipartPost:
            [self sendMutiPartRequest:apiRequest withCompletion:completion];
            break;
        default:
            break;
    }
    
}

- (void)sendMutiPartRequest:(ApiRequest *)apiRequest withCompletion:(void (^)(id data, NSError *error))completion {
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:apiRequest.url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < apiRequest.images.count; i ++) {
            [formData appendPartWithFormData:[apiRequest.images objectAtIndex:i] name:[NSString stringWithFormat:@"%@%d", @"image", i]];
        }
        [formData appendPartWithFormData:[[apiRequest.parameters toJsonString] dataUsingEncoding:NSUTF8StringEncoding] name:@"paramter"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)sendGetRequest:(ApiRequest *)apiRequest withCompletion:(void (^)(id data, NSError *error))completion {
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger GET:apiRequest.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)sendPostRequest:(ApiRequest *)apiRequest withCompletion:(void (^)(id data, NSError *error))completion {
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:apiRequest.url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded"
   forHTTPHeaderField:@"Contsetent-Type"];
    [request setHTTPBody:[[apiRequest.parameters toJsonString] dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperation *operation = [manger HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    [manger.operationQueue addOperation:operation];
}

@end
