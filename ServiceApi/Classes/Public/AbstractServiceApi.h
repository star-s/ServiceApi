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

@interface AbstractServiceApi : NSObject

+ (void)setResponseTransformer:(nullable NSValueTransformer *)transformer forServicePath:(NSString *)servicePath;

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

@interface AbstractServiceApi (ServiceApiDeprecated)

+ (NSProgress *)post:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion DEPRECATED_ATTRIBUTE;

+ (NSProgress *)get:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion DEPRECATED_ATTRIBUTE;

+ (NSProgress *)put:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion DEPRECATED_ATTRIBUTE;

+ (NSProgress *)patch:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion DEPRECATED_ATTRIBUTE;

+ (NSProgress *)delete:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion DEPRECATED_ATTRIBUTE;

+ (NSProgress *)post:(NSString *)servicePath
           formParts:(NSArray <id <AbstractFormPart>> *)parts
               names:(NSArray <NSString *> *)names
          completion:(ServiceApiResultBlock)completion DEPRECATED_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
