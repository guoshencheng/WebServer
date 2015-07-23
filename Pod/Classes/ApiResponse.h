//
//  ApiResponse.h
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

/**
 * This is the class which saves response returned from server
 *
 * When data returned by AFNetworking, we transform it into NSDictionary and Assign the NSDictionary into this class
 * This class also provide some function of checking response status
 * To explan the Response to DTO or Other data models, please new a category maybe called "ApiResponse+Explanation.h&m" and add some function like：
 - (DTO *)transformIntoDTO {
 some handler functions
 return some DTOs;
 }
 **/

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
