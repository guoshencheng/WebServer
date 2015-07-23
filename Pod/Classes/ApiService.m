//
//  ApiService.m
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import "ApiService.h"
#import "AFNetworking.h"
#import "NSDictionary+WebServer.h"

@implementation ApiService

#pragma mark - Public Methods

+ (instancetype)serviceWithDelegate:(id<ApiServiceDelegate>)delegate {
    ApiService *service = [[self alloc] init];
    service.delegate = delegate;
    return service;
}

- (void)sendReLoginWithRequest:(ApiRequest *)apiRequest andLoginRequest:(ApiRequest *)reloginRequest {
    [self sendPostOrPutRequest:reloginRequest withCompletion:^(id data, NSError *error) {
        if (error) {
            [self sendFailDelegateWithApiRequest:apiRequest andError:error];
        } else {
            ApiResponse *apiResponse = [ApiResponse responseWithDictionary:data error:&error];
            if (error) {
                [self sendFailDelegateWithApiRequest:apiRequest andError:error];
            } else {
                if ([apiResponse success]) {
                    [self sendRequest:apiRequest];
                }
            }
        }
    }];
}

- (void)sendRequest:(ApiRequest *)apiRequest {
    [self sendRequest:apiRequest withCompletion:^(id dictionary, NSError *error) {
        if (error) {
            [self sendFailDelegateWithApiRequest:apiRequest andError:error];
        } else {
            ApiResponse *apiResponse = [ApiResponse responseWithDictionary:dictionary error:&error];
            if (!error) {
                if ([self.delegate respondsToSelector:@selector(service:didFinishRequest:withResponse:)]) {
                    [self.delegate service:self didFinishRequest:apiRequest withResponse:apiResponse];
                }
            } else {
                [self sendFailDelegateWithApiRequest:apiRequest andError:error];
            }
        }
    }];
}

#pragma mark - Private Methods

/**
 * The function is a router juge by apiRequest.method
 **/
- (void)sendRequest:(ApiRequest *)apiRequest withCompletion:(void (^)(id dictionary, NSError *error))completion {
    if ([self.delegate respondsToSelector:@selector(service:willStartRequest:)]) {
        [self.delegate service:self willStartRequest:apiRequest];
    }
    switch (apiRequest.method) {
        case ApiRequestMethodGet:
            [self sendGetRequest:apiRequest withCompletion:completion];
            break;
        case ApiRequestMethodPost:
            [self sendPostOrPutRequest:apiRequest withCompletion:completion];
            break;
        case ApiRequestMethodMutipartPost:
            [self sendMutiPartRequest:apiRequest withCompletion:completion];
            break;
        case ApiRequestMethodDelete:
            [self sendDeleteRequest:apiRequest withCompletion:completion];
            break;
        case ApiRequestMethodPut:
            [self sendPostOrPutRequest:apiRequest withCompletion:completion];
            break;
        default:
            break;
    }
    
}

/**
 * The Function send a Get Requst
 * To use the function, Url should confirm when ApiRequst Object created
 **/
- (void)sendGetRequest:(ApiRequest *)apiRequest withCompletion:(void (^)(id data, NSError *error))completion {
    AFHTTPRequestOperationManager *manger = [ApiService createDefaultRequestManger];
    [manger GET:apiRequest.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleResponseObject:responseObject withCompletion:completion];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

/**
 * The Function send a Delete Requst
 * To use the function, Url should confirm when ApiRequst Object created
 **/
- (void)sendDeleteRequest:(ApiRequest *)apiRequest withCompletion:(void (^)(id data, NSError *error))completion {
    AFHTTPRequestOperationManager *manger = [ApiService createDefaultRequestManger];
    [manger DELETE:apiRequest.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleResponseObject:responseObject withCompletion:completion];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

/**
 * The Function send a Post or Put Requst
 * It will auto juge Post or Put type by ApiRequest.method and transform paramter into JSon and add it into body
 **/
- (void)sendPostOrPutRequest:(ApiRequest *)apiRequest withCompletion:(void (^)(id data, NSError *error))completion {
    AFHTTPRequestOperationManager *manger = [ApiService createDefaultRequestManger];
    NSMutableURLRequest *request = [ApiService createRequestWithApiRequest:apiRequest];
    NSOperation *operation = [manger HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleResponseObject:responseObject withCompletion:completion];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    [manger.operationQueue addOperation:operation];
}

/**
 * The Function send a Mutipart Requst
 * It will auto juge path or filedata type by ApiRequst.files or paths and append those into formdata
 **/
- (void)sendMutiPartRequest:(ApiRequest *)apiRequest withCompletion:(void (^)(id data, NSError *error))completion {
    AFHTTPRequestOperationManager *manger = [ApiService createDefaultRequestManger];
    [manger POST:apiRequest.url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [ApiService appendFormDataWithApiRequest:apiRequest andFormData:formData];
        [formData appendPartWithFormData:[[apiRequest.parameters toJsonString] dataUsingEncoding:NSUTF8StringEncoding] name:@"paramter"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleResponseObject:responseObject withCompletion:completion];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

#pragma mark - PrivateTools

- (void)handleResponseObject:(id)responseObject withCompletion:(void (^)(id data, NSError *error))completion {
    NSError *error = nil;
    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
    completion(responseObject, error);
}

- (void)sendFailDelegateWithApiRequest:(ApiRequest *)apiRequest andError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(service:didFailRequest:withError:)]) {
        [self.delegate service:self didFailRequest:apiRequest withError:error];
    }
}

+ (void)appendFormDataWithApiRequest:(ApiRequest *)apiRequest andFormData:(id<AFMultipartFormData>) formData {
    if (apiRequest.files && apiRequest.files.count > 0) {
        [ApiService appendFormDataWithFiles:apiRequest.files andFormData:formData];
    }
    if (apiRequest.paths && apiRequest.paths.count > 0) {
        [ApiService appendFormDataWithPath:apiRequest.paths andFormData:formData];
    }
}

+ (void)appendFormDataWithFiles:(NSArray *)files andFormData:(id<AFMultipartFormData>) formData {
    for (int i = 0; i < files.count; i ++) {
        [formData appendPartWithFileData:[files objectAtIndex:i] name:[NSString stringWithFormat:@"%@%d", @"file_", i] fileName:[NSString stringWithFormat:@"%@%d", @"file_", i] mimeType:@"png"];
    }
}

+ (void)appendFormDataWithPath:(NSArray *)paths andFormData:(id<AFMultipartFormData>) formData {
    for (int i = 0; i < paths.count; i ++) {
        [formData appendPartWithFileURL:[paths objectAtIndex:i] name:[NSString stringWithFormat:@"%@%d", @"file_for_path_", i] error:nil];
    }
}

+ (AFHTTPRequestOperationManager *)createDefaultRequestManger {
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    return manger;
}

+ (NSMutableURLRequest *)createRequestWithApiRequest:(ApiRequest *)apiRequest {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:apiRequest.url]];
    [request setHTTPMethod:((apiRequest.method == ApiRequestMethodPost) ? @"POST": @"PUT")];
    [request setValue:@"application/x-www-form-urlencoded"
   forHTTPHeaderField:@"Contsetent-Type"];
    [request setHTTPBody:[[apiRequest.parameters toJsonString] dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

@end
