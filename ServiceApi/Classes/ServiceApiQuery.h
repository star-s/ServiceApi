//
//  ServiceApiQuery.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 12.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessHandleBlock)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);
typedef void(^FailureHandleBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

NS_ASSUME_NONNULL_BEGIN

@interface ServiceApiQuery : NSObject

@property (nonatomic, readonly) id parameters;

@property (nonatomic, copy, readonly) NSString *URLString;

@property (nonatomic, copy, readonly) SuccessHandleBlock success;
@property (nonatomic, copy, readonly) FailureHandleBlock failure;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithURLString:(NSString *)URLString parameters:(id)parameters success:(SuccessHandleBlock)success failure:(FailureHandleBlock)failure;

@end

NS_ASSUME_NONNULL_END
