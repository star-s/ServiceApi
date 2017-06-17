//
//  AbstractServiceApi+ServiceApiDeprecated.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 17.06.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <ServiceApi/ServiceApi.h>

NS_ASSUME_NONNULL_BEGIN

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
