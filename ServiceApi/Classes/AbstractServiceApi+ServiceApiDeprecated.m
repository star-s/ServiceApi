//
//  AbstractServiceApi+ServiceApiDeprecated.m
//  ServiceApi
//
//  Created by Sergey Starukhin on 17.06.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "AbstractServiceApi+ServiceApiDeprecated.h"

@implementation AbstractServiceApi (ServiceApiDeprecated)

+ (NSProgress *)post:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    return [self POST: servicePath request: request completion: completion];
}

+ (NSProgress *)get:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    return [self GET: servicePath request: request completion: completion];
}

+ (NSProgress *)put:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    return [self PUT: servicePath request: request completion: completion];
}

+ (NSProgress *)patch:(NSString *)servicePath request:(id)request completion:(ServiceApiResultBlock)completion
{
    return [self PATCH: servicePath request: request completion: completion];
}

+ (NSProgress *)delete:(NSString *)servicePath request:(id)request completion:(ServiceApiResultBlock)completion
{
    return [self DELETE: servicePath request: request completion: completion];
}

+ (NSProgress *)post:(NSString *)servicePath
           formParts:(NSArray <id <AbstractFormPart>> *)parts
               names:(NSArray <NSString *> *)names
          completion:(ServiceApiResultBlock)completion
{
    return [self POST: servicePath formParts: parts names: names completion: completion];
}

@end
