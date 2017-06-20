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

@interface AbstractServiceApi ()

- (NSProgress *)GET:(ServiceApiQuery *)query;
- (NSProgress *)POST:(ServiceApiQuery *)query;
- (NSProgress *)PUT:(ServiceApiQuery *)query;
- (NSProgress *)PATCH:(ServiceApiQuery *)query;
- (NSProgress *)DELETE:(ServiceApiQuery *)query;

@end

@implementation AbstractServiceApi

+ (NSValueTransformer *)responseTransformerForServicePath:(NSString *)servicePath HTTPMethod:(NSString *)method
{
    __block NSValueTransformer *result = nil;
    
    NSArray *names = [NSArray arrayWithObjects: servicePath, [method.uppercaseString stringByAppendingString: servicePath], nil];
    
    [names enumerateObjectsWithOptions: NSEnumerationReverse usingBlock: ^(NSString * _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        result = [NSValueTransformer valueTransformerForName: name];
        *stop = result != nil;
    }];
    return result;
}

#pragma mark - Public API

+ (void)setResponseTransformer:(nullable NSValueTransformer *)transformer forServicePath:(NSString *)servicePath HTTPMethod:(NSString *)method
{
    NSString *name = method.length ? [method.uppercaseString stringByAppendingString: servicePath] : servicePath;
    [NSValueTransformer setValueTransformer: transformer forName: name];
}

+ (void)setResponseTransformer:(nullable NSValueTransformer *)transformer forServicePath:(NSString *)servicePath
{
    [self setResponseTransformer: transformer forServicePath: servicePath HTTPMethod: @""];
}

+ (NSProgress *)POST:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    AbstractServiceApi *api = [self sharedInstance];
    return [api POST: [api queryWithHTTPMethod: @"POST" servicePath: servicePath request: request completion: completion]];
}

+ (NSProgress *)GET:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    AbstractServiceApi *api = [self sharedInstance];
    return [api GET: [api queryWithHTTPMethod: @"GET" servicePath: servicePath request: request completion: completion]];
}

+ (NSProgress *)PUT:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    AbstractServiceApi *api = [self sharedInstance];
    return [api PUT: [api queryWithHTTPMethod: @"PUT" servicePath: servicePath request: request completion: completion]];
}

+ (NSProgress *)PATCH:(NSString *)servicePath request:(id)request completion:(ServiceApiResultBlock)completion
{
    AbstractServiceApi *api = [self sharedInstance];
    return [api PATCH: [api queryWithHTTPMethod: @"PATCH" servicePath: servicePath request: request completion: completion]];
}

+ (NSProgress *)DELETE:(NSString *)servicePath request:(id)request completion:(ServiceApiResultBlock)completion
{
    AbstractServiceApi *api = [self sharedInstance];
    return [api DELETE: [api queryWithHTTPMethod: @"DELETE" servicePath: servicePath request: request completion: completion]];
}

+ (NSProgress *)POST:(NSString *)servicePath
           formParts:(NSArray <id <AbstractFormPart>> *)parts
               names:(NSArray <NSString *> *)names
          completion:(ServiceApiResultBlock)completion
{
    AbstractServiceApi *api = [self sharedInstance];
    return [api POST: [api queryWithServicePath: servicePath formParts: parts names: names completion: completion]];
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

- (NSValueTransformer *)requestTransformer
{
    return nil;
}

- (void)handleResponseObject:(id)responseObject forQuery:(ServiceApiQuery *)query
{
    [query performCallback: responseObject];
}

- (void)handleError:(NSError *)error forQuery:(ServiceApiQuery *)query
{
    [query performCallback: error];
}

#pragma mark - Internal stuff

- (NSValueTransformer *)responseTransformerForServicePath:(NSString *)servicePath HTTPMethod:(NSString *)method
{
    return [self.class responseTransformerForServicePath: servicePath HTTPMethod: method];
}

- (ServiceApiQuery *)queryWithHTTPMethod:(NSString *)method
                             servicePath:(NSString *)servicePath
                                 request:(id)request
                              completion:(ServiceApiResultBlock)completion
{
    id parameters = self.requestTransformer ? [self.requestTransformer transformedValue: request] : request;
    ServiceApiQuery *result = [[ServiceApiQuery alloc] initWithURLString: servicePath parameters: parameters];
    result.responseTransformer = [self responseTransformerForServicePath: servicePath HTTPMethod: method];
    result.callback = completion;
    return result;
}

- (ServiceApiQuery *)queryWithServicePath:(NSString *)servicePath
                                formParts:(NSArray <id <AbstractFormPart>> *)parts
                                    names:(NSArray <NSString *> *)names
                               completion:(ServiceApiResultBlock)completion
{
    NSParameterAssert(parts.count == names.count);

    ServiceApiMultiPartsQuery *result = [[ServiceApiMultiPartsQuery alloc] initWithURLString: servicePath parameters: nil];
    result.parts = parts;
    result.names = names;
    result.responseTransformer = [self responseTransformerForServicePath: servicePath HTTPMethod: @"POST"];
    result.callback = completion;
    return result;
}

- (NSProgress *)POST:(ServiceApiMultiPartsQuery *)query
{
    return [self.transport service: self POST: query];
}

- (NSProgress *)GET:(ServiceApiQuery *)query
{
    return [self.transport service: self GET: query];
}

- (NSProgress *)PUT:(ServiceApiQuery *)query
{
    return [self.transport service: self PUT: query];
}

- (NSProgress *)PATCH:(ServiceApiQuery *)query
{
    return [self.transport service: self PATCH: query];
}

- (NSProgress *)DELETE:(ServiceApiQuery *)query
{
    return [self.transport service: self DELETE: query];
}

@end
