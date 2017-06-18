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

+ (NSValueTransformer *)responseTransformerForServicePath:(NSString *)servicePath HTTPMethod:(NSString *)method
{
    NSValueTransformer *result = nil;
    
    if (method.length) {
        result = [NSValueTransformer valueTransformerForName: [method.uppercaseString stringByAppendingString: servicePath]];
    }
    if (result == nil) {
        result = [NSValueTransformer valueTransformerForName: servicePath];
    }
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

- (instancetype)initWithRequestTransformer:(NSValueTransformer *)transformer
{
    self = [super init];
    if (self) {
        _requestTransformer = transformer;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithRequestTransformer: nil];
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
    [NSException raise: NSInvalidArgumentException format: @"*** -%@ only defined for abstract class.  Define -[%@ %@]!", NSStringFromSelector(_cmd), NSStringFromClass(self.class), NSStringFromSelector(_cmd)];
    return nil;
}

- (NSProgress *)GET:(ServiceApiQuery *)query
{
    [NSException raise: NSInvalidArgumentException format: @"*** -%@ only defined for abstract class.  Define -[%@ %@]!", NSStringFromSelector(_cmd), NSStringFromClass(self.class), NSStringFromSelector(_cmd)];
    return nil;
}

- (NSProgress *)PUT:(ServiceApiQuery *)query
{
    [NSException raise: NSInvalidArgumentException format: @"*** -%@ only defined for abstract class.  Define -[%@ %@]!", NSStringFromSelector(_cmd), NSStringFromClass(self.class), NSStringFromSelector(_cmd)];
    return nil;
}

- (NSProgress *)PATCH:(ServiceApiQuery *)query
{
    [NSException raise: NSInvalidArgumentException format: @"*** -%@ only defined for abstract class.  Define -[%@ %@]!", NSStringFromSelector(_cmd), NSStringFromClass(self.class), NSStringFromSelector(_cmd)];
    return nil;
}

- (NSProgress *)DELETE:(ServiceApiQuery *)query
{
    [NSException raise: NSInvalidArgumentException format: @"*** -%@ only defined for abstract class.  Define -[%@ %@]!", NSStringFromSelector(_cmd), NSStringFromClass(self.class), NSStringFromSelector(_cmd)];
    return nil;
}

- (void)setDebug:(BOOL)enable
{
    _debug = enable;
}

@end
