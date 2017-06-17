//
//  NetworkServiceApi_Private.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 17.06.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <ServiceApi/NetworkServiceApi.h>

@class AFHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface NetworkServiceApi ()

@property (nonatomic, readonly) __kindof AFHTTPSessionManager *sessionManager;

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)manager requestTransformer:(nullable NSValueTransformer *)transformer;

@end

NS_ASSUME_NONNULL_END
