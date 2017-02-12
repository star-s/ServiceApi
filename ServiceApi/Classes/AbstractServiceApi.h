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

+ (void)setRequestTransformer:(nullable NSValueTransformer *)transformer;

+ (NSProgress *)post:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)get:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)put:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)post:(NSString *)servicePath
           formParts:(NSArray <id <AbstractFormPart>> *)parts
               names:(NSArray <NSString *> *)names
          completion:(ServiceApiResultBlock)completion;

@end

NS_ASSUME_NONNULL_END
