//
//  ApiRequest.h
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STATUS_URL @"http://10.0.2.217:9999/api/statuses"
#define LOGIN_URL @"http://10.0.2.217:9999/api/login"
#define IMAGE_URL @"http://10.0.2.217:9999/api/images"
#define STATUS_USERID_URL @"http://10.0.2.217:9999/api/user/%d/statuses"
#define MUTIPART_FILE_UPLOAD_URL @"http://192.168.1.107:3000/"

typedef enum {
    ApiRequestMethodGet,
    ApiRequestMethodPost,
    ApiRequestMethodMutipartPost,
} ApiRequestMethod;

@interface ApiRequest : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, assign) ApiRequestMethod method;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray *images;

+ (instancetype)requestForTestServer;
+ (instancetype)requestForGetAllUserAllStatus;
+ (instancetype)requestForGetAllStatusWithId:(NSInteger)userId;

+ (instancetype)requestForUploadPictureWithUserId:(NSString *)userId andImage:(UIImage *)image;
+ (instancetype)requestForLoginWithUserId:(NSString *)userId nickName:(NSString *)nickName avatarUrl:(NSString *)avatarUrl;
+ (instancetype)requestForCreateStatusWithDetails:(NSString *)details location:(NSString *)location imageUrls:(NSArray *)imageUrls;
+ (instancetype)requestForMutipartUploadWithPaths:(NSArray *)images;
- (NSString *)assembleParameters;

@end
