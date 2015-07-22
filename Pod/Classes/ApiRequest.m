//
//  ApiRequest.m
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import "ApiRequest.h"
#import "NSBase64.h"

@implementation ApiRequest

#pragma mrak - PublicMethod

- (NSString *)assembleParameters {
    NSMutableArray *parts = [NSMutableArray array];
    for (NSString *key in [self.parameters allKeys]) {
        NSString *part = [NSString stringWithFormat:@"%@=%@", key, [self.parameters valueForKey:key]];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

#pragma mark - FactoryMethod

+ (instancetype)requestForTestServer {
    ApiRequest *request = [self defaultRequest];
    request.url = @"http://10.0.2.217:8888/api";
    request.parameters = @{@"id":@"books" };
    return  request;
}

+ (instancetype)requestForGetAllUserAllStatus {
    ApiRequest *request = [self defaultRequest];
    request.url = STATUS_URL;
    request.parameters = nil;
    return request;
}

+ (instancetype)requestForGetAllStatusWithId:(NSInteger)userId {
    ApiRequest *request = [self defaultRequest];
    request.url = [NSString stringWithFormat:STATUS_USERID_URL, userId];
    request.parameters = nil;
    return request;
}

+ (instancetype)requestForLoginWithUserId:(NSString *)userId nickName:(NSString *)nickName avatarUrl:(NSString *)avatarUrl {
    ApiRequest *request = [self defaultRequest];
    request.method = ApiRequestMethodPost;
    request.url = LOGIN_URL;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:nickName forKey:@"nickName"];
    [dic setValue:avatarUrl forKey:@"avatarUrl"];
    request.parameters = [ApiRequest createPostParametersWithParameters:dic];
    return request;
}

+ (instancetype)requestForCreateStatusWithDetails:(NSString *)details location:(NSString *)location imageUrls:(NSArray *)imageUrls {
    ApiRequest *request = [self defaultRequest];
    request.method = ApiRequestMethodPost;
    request.url = STATUS_URL;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:details forKey:@"details"];
    [dic setValue:location forKey:@"location"];
    [dic setValue:imageUrls forKey:@"imageUrls"];
    [dic setValue:@(round([[NSDate date] timeIntervalSince1970] * 1000.0)) forKey:@"referTime"];
    request.parameters = [ApiRequest createPostParametersWithParameters:dic];
    return request;
}

+ (instancetype)requestForUploadPictureWithUserId:(NSString *)userId andImage:(UIImage *)image {
    ApiRequest *request = [self defaultRequest];
    request.method = ApiRequestMethodPost;
    request.url = IMAGE_URL;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:@((NSInteger)([[NSDate date] timeIntervalSince1970] * 1000)) forKey:@"referTime"];
    NSString *imageString =  [UIImageJPEGRepresentation(image, 0.2) base64EncodedString];
    [dic setValue:imageString forKey:@"imageString"];
    request.parameters = [ApiRequest createPostParametersWithParameters:dic];
    return request;
}

+ (instancetype)requestForMutipartUploadWithPaths:(NSArray *)images {
    ApiRequest *request = [self defaultRequest];
    request.method = ApiRequestMethodMutipartPost;
    request.url = MUTIPART_FILE_UPLOAD_URL;
    request.parameters = [ApiRequest createPostParametersWithParameters:@{}];
    request.images = [[NSMutableArray alloc] init];
    for (UIImage *image in images) {
        [request.images addObject:[[UIImageJPEGRepresentation(image, 0.2) base64EncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return request;
}

#pragma mark - Private Methods

+ (instancetype)defaultRequest {
    ApiRequest *request = [[ApiRequest alloc] init];
    request.method = ApiRequestMethodGet;
    request.parameters = [NSMutableDictionary dictionary];
    return request;
}

+ (NSDictionary *)createPostParametersWithParameters:(NSDictionary *)parameters {
    return @{@"version":@"1.0", @"encoding":@"UTF-8", @"entity":@{@"model":parameters}};
}

@end
