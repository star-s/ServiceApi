//
//  AbstractServiceApi.m
//  ServiceApi
//
//  Created by Sergey Starukhin on 11.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "AbstractServiceApi_private.h"
#import "ServiceApiQuery.h"
#import "ServiceApiFormPartProtocol.h"
#import <objc/runtime.h>

@import AFNetworking;

typedef void(^SuccessBlock)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

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

@implementation AbstractServiceApi

#pragma mark - Public API

+ (void)setResponseTransformer:(nullable NSValueTransformer *)transformer forServicePath:(NSString *)servicePath
{
    [NSValueTransformer setValueTransformer: transformer forName: servicePath];
}

+ (NSProgress *)POST:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    AbstractServiceApi *api = [self sharedInstance];
    return [api POST: [api queryWithServicePath: servicePath request: request completion: completion]];
}

+ (NSProgress *)GET:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    AbstractServiceApi *api = [self sharedInstance];
    return [api GET: [api queryWithServicePath: servicePath request: request completion: completion]];
}

+ (NSProgress *)PUT:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    AbstractServiceApi *api = [self sharedInstance];
    return [api PUT: [api queryWithServicePath: servicePath request: request completion: completion]];
}

+ (NSProgress *)PATCH:(NSString *)servicePath request:(id)request completion:(ServiceApiResultBlock)completion
{
    AbstractServiceApi *api = [self sharedInstance];
    return [api PATCH: [api queryWithServicePath: servicePath request: request completion: completion]];
}

+ (NSProgress *)DELETE:(NSString *)servicePath request:(id)request completion:(ServiceApiResultBlock)completion
{
    AbstractServiceApi *api = [self sharedInstance];
    return [api DELETE: [api queryWithServicePath: servicePath request: request completion: completion]];
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

- (instancetype)init
{
    return [self initWithSessionManager: [AFHTTPSessionManager manager] requestTransformer: [[NSValueTransformer alloc] init]];
}

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)manager requestTransformer:(NSValueTransformer *)transformer
{
    self = [super init];
    if (self) {
        _sessionManager = manager;
        _requestTransformer = transformer;
    }
    return self;
}

- (void)handleResponseObject:(id)responseObject forQuery:(ServiceApiQuery *)query
{
    [query performCallback: responseObject];
}

- (void)handleError:(NSError *)error forQuery:(ServiceApiQuery *)query
{
    [query performCallback: error];
}

- (ServiceApiQuery *)queryWithServicePath:(NSString *)servicePath
                                  request:(nullable id)request
                               completion:(ServiceApiResultBlock)completion
{
    ServiceApiQuery *result = [[ServiceApiQuery alloc] initWithURLString: servicePath
                                                              parameters: [self.requestTransformer transformedValue: request]];
    result.responseTransformer = [NSValueTransformer valueTransformerForName: servicePath];
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
    result.responseTransformer = [NSValueTransformer valueTransformerForName: servicePath];
    result.callback = completion;
    return result;
}

- (NSProgress *)POST:(ServiceApiMultiPartsQuery *)query
{
    AFHTTPSessionManager *sessionManager = self.sessionManager;
    
    SuccessBlock success = ^(NSURLSessionDataTask *task, id _Nullable responseObject){
        [self handleResponseObject: responseObject forQuery: query];
    };
    FailureBlock failure = ^(NSURLSessionDataTask * _Nullable task, NSError *error){
        [self handleError: error forQuery: query];
    };
    NSURLSessionTask *task = nil;
    
    if ([query isKindOfClass: [ServiceApiMultiPartsQuery class]]) {
        //
        task = [sessionManager POST: query.URLString
                         parameters: query.parameters
          constructingBodyWithBlock: ^(id<AFMultipartFormData>  _Nonnull formData){
              //
              [query.parts enumerateObjectsUsingBlock: ^(id<AbstractFormPart>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  //
                  NSString *partName = query.names[idx];
                  
                  if ([obj conformsToProtocol: @protocol(DataFormPart)]) {
                      //
                      id <DataFormPart> formPart = (id <DataFormPart>)obj;
                      
                      [formData appendPartWithFileData: [formPart data]
                                                  name: partName
                                              fileName: [formPart fileName]
                                              mimeType: [formPart mimeType]];
                      
                  } else if ([obj conformsToProtocol: @protocol(FileFormPart)]) {
                      //
                      id <FileFormPart> formPart = (id <FileFormPart>)obj;
                      
                      [formData appendPartWithFileURL: [formPart fileURL]
                                                 name: partName
                                             fileName: [formPart fileName]
                                             mimeType: [formPart mimeType]
                                                error: NULL];
                      
                  } else if ([obj conformsToProtocol: @protocol(StreamFormPart)]) {
                      //
                      id <StreamFormPart> formPart = (id <StreamFormPart>)obj;
                      
                      [formData appendPartWithInputStream: [formPart inputStream]
                                                     name: partName
                                                 fileName: [formPart fileName]
                                                   length: [formPart inputStreamLength]
                                                 mimeType: [formPart mimeType]];
                  } else {
                      [NSException raise: NSInvalidArgumentException format: @"Object %@ conform only abstract protocol", obj];
                  }
              }];
          }
                           progress: NULL
                            success: success
                            failure: failure];
    } else {
        task = [sessionManager POST: query.URLString
                         parameters: query.parameters
                           progress: NULL
                            success: success
                            failure: failure];
    }
    return [sessionManager uploadProgressForTask: task];
}

- (NSProgress *)GET:(ServiceApiQuery *)query
{
    AFHTTPSessionManager *sessionManager = self.sessionManager;
    
    NSURLSessionTask *task = [sessionManager GET: query.URLString
                                      parameters: query.parameters
                                        progress: NULL
                                         success: ^(NSURLSessionDataTask *task, id _Nullable responseObject){
                                             [self handleResponseObject: responseObject forQuery: query];
                                         }
                                         failure: ^(NSURLSessionDataTask * _Nullable task, NSError *error){
                                             [self handleError: error forQuery: query];
                                         }];
    
    return [sessionManager downloadProgressForTask: task];
}

- (NSProgress *)PUT:(ServiceApiQuery *)query
{
    AFHTTPSessionManager *sessionManager = self.sessionManager;
    
    NSURLSessionTask *task = [sessionManager PUT: query.URLString
                                      parameters: query.parameters
                                         success: ^(NSURLSessionDataTask *task, id _Nullable responseObject){
                                             [self handleResponseObject: responseObject forQuery: query];
                                         }
                                         failure: ^(NSURLSessionDataTask * _Nullable task, NSError *error){
                                             [self handleError: error forQuery: query];
                                         }];
    
    return [sessionManager uploadProgressForTask: task];
}

- (NSProgress *)PATCH:(ServiceApiQuery *)query
{
    AFHTTPSessionManager *sessionManager = self.sessionManager;
    
    NSURLSessionTask *task = [sessionManager PATCH: query.URLString
                                        parameters: query.parameters
                                           success: ^(NSURLSessionDataTask *task, id _Nullable responseObject){
                                               [self handleResponseObject: responseObject forQuery: query];
                                           }
                                           failure: ^(NSURLSessionDataTask * _Nullable task, NSError *error){
                                               [self handleError: error forQuery: query];
                                           }];
    
    return [sessionManager uploadProgressForTask: task];
}

- (NSProgress *)DELETE:(ServiceApiQuery *)query
{
    AFHTTPSessionManager *sessionManager = self.sessionManager;
    
    NSURLSessionTask *task = [sessionManager DELETE: query.URLString
                                         parameters: query.parameters
                                            success: ^(NSURLSessionDataTask *task, id _Nullable responseObject){
                                                [self handleResponseObject: responseObject forQuery: query];
                                            }
                                            failure: ^(NSURLSessionDataTask * _Nullable task, NSError *error){
                                                [self handleError: error forQuery: query];
                                            }];
    
    return [sessionManager uploadProgressForTask: task];
}

- (void)setDebug:(BOOL)enable
{
    AFJSONRequestSerializer *requestSerializer = (AFJSONRequestSerializer *)self.sessionManager.requestSerializer;
    
    if ([requestSerializer isKindOfClass: [AFJSONRequestSerializer class]]) {
        requestSerializer.writingOptions = enable ? NSJSONWritingPrettyPrinted : kNilOptions;
    }
    _debug = enable;
}

@end
