//
//  AbstractServiceApi.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 11.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbstractFormPart;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ServiceApiResultBlock)(id _Nullable resultObject, NSError * _Nullable error);

typedef NSString *ServiceApiHttpMethod NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXPORT ServiceApiHttpMethod const ServiceApiHttpMethodPost;
FOUNDATION_EXPORT ServiceApiHttpMethod const ServiceApiHttpMethodGet;
FOUNDATION_EXPORT ServiceApiHttpMethod const ServiceApiHttpMethodPut;
FOUNDATION_EXPORT ServiceApiHttpMethod const ServiceApiHttpMethodPatch;
FOUNDATION_EXPORT ServiceApiHttpMethod const ServiceApiHttpMethodDelete;

@interface AbstractServiceApi : NSObject

+ (void)setResponseTransformer:(nullable NSValueTransformer *)transformer forServicePath:(NSString *)servicePath;

+ (void)setResponseTransformer:(nullable NSValueTransformer *)transformer forServicePath:(NSString *)servicePath HTTPMethod:(ServiceApiHttpMethod)method;

+ (NSProgress *)POST:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)GET:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)PUT:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)PATCH:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)DELETE:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)POST:(NSString *)servicePath
           formParts:(NSArray <id <AbstractFormPart>> *)parts
               names:(NSArray <NSString *> *)names
          completion:(ServiceApiResultBlock)completion;

+ (void)setDebug:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
