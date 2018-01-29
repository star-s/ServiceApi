//
//  AbstractServiceApi.m
//  ServiceApi
//
//  Created by Sergey Starukhin on 11.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "AbstractServiceApi_Private.h"
#import "ServiceApiQuery.h"
#import <objc/runtime.h>

@implementation AbstractServiceApi

#pragma mark - Public API

+ (NSProgress *)POST:(NSString *)servicePath
             request:(nullable id)request
 responseTransformer:(nullable id <Transformer>)transformer
          completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] POST: servicePath request: request responseTransformer: transformer completion: completion];
}

+ (NSProgress *)GET:(NSString *)servicePath
            request:(nullable id)request
responseTransformer:(nullable id <Transformer>)transformer
         completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] GET: servicePath request: request responseTransformer: transformer completion: completion];
}

+ (NSProgress *)PUT:(NSString *)servicePath
            request:(nullable id)request
responseTransformer:(nullable id <Transformer>)transformer
         completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] PUT: servicePath request: request responseTransformer: transformer completion: completion];
}

+ (NSProgress *)PATCH:(NSString *)servicePath
              request:(nullable id)request
  responseTransformer:(nullable id <Transformer>)transformer
           completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] PATCH: servicePath request: request responseTransformer: transformer completion: completion];
}

+ (NSProgress *)DELETE:(NSString *)servicePath
               request:(nullable id)request
   responseTransformer:(nullable id <Transformer>)transformer
            completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] DELETE: servicePath request: request responseTransformer: transformer completion: completion];
}

+ (NSProgress *)POST:(NSString *)servicePath
           formParts:(NSArray <id <AbstractFormPart>> *)parts
               names:(NSArray <NSString *> *)names
 responseTransformer:(nullable id <Transformer>)transformer
          completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] POST: servicePath formParts: parts names: names responseTransformer: transformer completion: completion];
}

+ (void)setDebug:(BOOL)enable
{
    [[self sharedInstance] setDebug: enable];
}

#pragma mark - Private API

+ (instancetype)sharedInstance
{
    NSAssert([[self superclass] isSubclassOfClass: [AbstractServiceApi class]], @"Method %@ must be called only from subclasses %@", NSStringFromSelector(_cmd), NSStringFromClass([AbstractServiceApi class]));

    AbstractServiceApi *sharedService = nil;
    
    @synchronized (self) {
        //
        sharedService = objc_getAssociatedObject(self, _cmd);
        
        if (sharedService == nil) {
            sharedService = [[self alloc] init];
            objc_setAssociatedObject(self, _cmd, sharedService, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return sharedService;
}

- (void)handleResponseObject:(id)responseObject forQuery:(ServiceApiQuery *)query
{
    NSAssert([query isKindOfClass: [ServiceApiQuery class]], @"Unknown query class: %@", query);
    [query performCallback: responseObject];
}

- (void)handleError:(NSError *)error forQuery:(ServiceApiQuery *)query
{
    NSAssert([query isKindOfClass: [ServiceApiQuery class]], @"Unknown query class: %@", query);
    [query performCallback: error];
}

#pragma mark - Internal stuff

- (id <ServiceQuery>)queryWithServicePath:(NSString *)servicePath
                                  request:(nullable id)request
                      responseTransformer:(nullable id <Transformer>)transformer
                               completion:(ServiceApiResultBlock)completion
{
    id parameters = self.requestTransformer ? [self.requestTransformer transformedValue: request] : request;
    ServiceApiQuery *result = [[ServiceApiQuery alloc] init];
    result.URLString = servicePath;
    result.parameters = parameters;
    result.responseTransformer = transformer;
    result.callback = completion;
    return result;
}

- (id <ServiceQuery>)queryWithServicePath:(NSString *)servicePath
                                  request:(nullable id)request
                                formParts:(NSArray <id <AbstractFormPart>> *)parts
                                    names:(NSArray <NSString *> *)names
                      responseTransformer:(nullable id <Transformer>)transformer
                               completion:(ServiceApiResultBlock)completion
{
    NSParameterAssert(parts.count == names.count);
    id parameters = self.requestTransformer ? [self.requestTransformer transformedValue: request] : request;
    ServiceApiMultiPartsQuery *result = [[ServiceApiMultiPartsQuery alloc] init];
    result.URLString = servicePath;
    result.parameters = parameters;
    result.parts = parts;
    result.names = names;
    result.responseTransformer = transformer;
    result.callback = completion;
    return result;
}

- (NSProgress *)POST:(NSString *)servicePath
             request:(nullable id)request
 responseTransformer:(nullable id <Transformer>)transformer
          completion:(ServiceApiResultBlock)completion
{
    NSAssert(self.transport, @"Transport is missing");
    id <ServiceQuery> query = [self queryWithServicePath: servicePath request: request responseTransformer: transformer completion: completion];
    return [self.transport service: self POST: query];
}

- (NSProgress *)GET:(NSString *)servicePath
            request:(nullable id)request
responseTransformer:(nullable id <Transformer>)transformer
         completion:(ServiceApiResultBlock)completion
{
    NSAssert(self.transport, @"Transport is missing");
    id <ServiceQuery> query = [self queryWithServicePath: servicePath request: request responseTransformer: transformer completion: completion];
    return [self.transport service: self GET: query];
}

- (NSProgress *)PUT:(NSString *)servicePath
            request:(nullable id)request
responseTransformer:(nullable id <Transformer>)transformer
         completion:(ServiceApiResultBlock)completion
{
    NSAssert(self.transport, @"Transport is missing");
    id <ServiceQuery> query = [self queryWithServicePath: servicePath request: request responseTransformer: transformer completion: completion];
    return [self.transport service: self PUT: query];
}

- (NSProgress *)PATCH:(NSString *)servicePath
              request:(nullable id)request
  responseTransformer:(nullable id <Transformer>)transformer
           completion:(ServiceApiResultBlock)completion
{
    NSAssert(self.transport, @"Transport is missing");
    id <ServiceQuery> query = [self queryWithServicePath: servicePath request: request responseTransformer: transformer completion: completion];
    return [self.transport service: self PATCH: query];
}

- (NSProgress *)DELETE:(NSString *)servicePath
               request:(nullable id)request
   responseTransformer:(nullable id <Transformer>)transformer
            completion:(ServiceApiResultBlock)completion
{
    NSAssert(self.transport, @"Transport is missing");
    id <ServiceQuery> query = [self queryWithServicePath: servicePath request: request responseTransformer: transformer completion: completion];
    return [self.transport service: self DELETE: query];
}

- (NSProgress *)POST:(NSString *)servicePath
           formParts:(NSArray <id <AbstractFormPart>> *)parts
               names:(NSArray <NSString *> *)names
 responseTransformer:(nullable id <Transformer>)transformer
          completion:(ServiceApiResultBlock)completion
{
    NSAssert(self.transport, @"Transport is missing");
    id <ServiceQuery> query = [self queryWithServicePath: servicePath request: nil formParts: parts names: names responseTransformer: transformer completion: completion];
    return [self.transport service: self POST: query];
}

@end
