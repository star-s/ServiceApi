//
//  AbstractServiceApi.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 11.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbstractFormPart, Transformer;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ServiceApiResultBlock)(id _Nullable resultObject, NSError * _Nullable error);

@interface AbstractServiceApi : NSObject

+ (NSProgress *)POST:(NSString *)servicePath
             request:(nullable id)request
 responseTransformer:(nullable id <Transformer>)transformer
          completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)GET:(NSString *)servicePath
            request:(nullable id)request
responseTransformer:(nullable id <Transformer>)transformer
         completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)PUT:(NSString *)servicePath
            request:(nullable id)request
responseTransformer:(nullable id <Transformer>)transformer
         completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)PATCH:(NSString *)servicePath
              request:(nullable id)request
  responseTransformer:(nullable id <Transformer>)transformer
           completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)DELETE:(NSString *)servicePath
               request:(nullable id)request
   responseTransformer:(nullable id <Transformer>)transformer
            completion:(ServiceApiResultBlock)completion;

+ (NSProgress *)POST:(NSString *)servicePath
           formParts:(NSArray <id <AbstractFormPart>> *)parts
               names:(NSArray <NSString *> *)names
 responseTransformer:(nullable id <Transformer>)transformer
          completion:(ServiceApiResultBlock)completion;

+ (void)setDebug:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
