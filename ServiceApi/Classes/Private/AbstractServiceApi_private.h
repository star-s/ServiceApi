//
//  AbstractServiceApi_private.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 11.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <ServiceApi/AbstractServiceApi.h>

@class AFHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

@interface AbstractServiceApi ()

@property (nonatomic, readonly) AFHTTPSessionManager *sessionManager;

+ (AbstractServiceApi *)sharedInstance;

- (nullable SuccessBlock)successBlockForServicePath:(NSString *)servicePath completion:(ServiceApiResultBlock)completion;

- (nullable FailureBlock)failureBlockForServicePath:(NSString *)servicePath completion:(ServiceApiResultBlock)completion;

@end

NS_ASSUME_NONNULL_END
