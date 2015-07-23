//
//  ApiResponse.h
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NotDictionaryFailed = -1000,
    
} WebServerErrorFailed;

@interface ApiResponse : NSObject

@property (nonatomic, assign) CGFloat version;
@property (nonatomic, strong) NSString *encoding;
@property (nonatomic, strong) NSArray *entities;
@property (nonatomic, strong) NSNumber *errorCode;
@property (nonatomic, strong) NSString *errorMsg;
@property (nonatomic, strong) NSDictionary *entity;

/**
 * a Create Function Explan Dictionary into ApiResponse
 **/
+ (instancetype)responseWithDictionary:(NSDictionary *)dictionary error:(NSError **)error;

/**
 * juge if success by errorCode
 **/
- (BOOL)success;

/**
 * juge if sessionTimeout by errorCode
 **/
- (BOOL)sessionTimeout;

@end
