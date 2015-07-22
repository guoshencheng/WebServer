//
//  ApiResponse.h
//  ArchitectureProject
//
//  Created by guoshencheng on 6/16/15.
//  Copyright (c) 2015 guoshencheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApiResponse : NSObject

@property (nonatomic, assign) CGFloat version;
@property (nonatomic, strong) NSString *encoding;
@property (nonatomic, strong) NSArray *entities;
@property (nonatomic, strong) NSNumber *errorCode;
@property (nonatomic, strong) NSString *errorMsg;
@property (nonatomic, strong) NSDictionary *entity;

+ (instancetype)responseWithDictionary:(NSDictionary *)dictionary error:(NSError *)error;

- (BOOL)success;
- (BOOL)sessionTimeout;

@end
