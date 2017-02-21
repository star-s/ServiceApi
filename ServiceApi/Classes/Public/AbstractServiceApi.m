//
//  AbstractServiceApi.m
//  ServiceApi
//
//  Created by Sergey Starukhin on 11.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "AbstractServiceApi_private.h"
#import "ServiceApiRequestParameters.h"
#import "ServiceApiFormPartProtocol.h"

@import AFNetworking;

@implementation AbstractServiceApi

#pragma mark - Public API

+ (void)setResponseTransformer:(nullable NSValueTransformer *)transformer forServicePath:(NSString *)servicePath
{
    [NSValueTransformer setValueTransformer: transformer forName: servicePath];
}

+ (void)setRequestTransformer:(nullable NSValueTransformer *)transformer
{
    NSAssert([[self superclass] isSubclassOfClass: [AbstractServiceApi class]], @"Method %@ must be called only from subclasses %@", NSStringFromSelector(_cmd), NSStringFromClass([AbstractServiceApi class]));
    [NSValueTransformer setValueTransformer: transformer forName: [self requestTransformerName]];
}

+ (NSProgress *)post:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] post: servicePath request: request completion: completion];
}

+ (NSProgress *)get:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] get: servicePath request: request completion: completion];
}

+ (NSProgress *)put:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] put: servicePath request: request completion: completion];
}

+ (NSProgress *)patch:(NSString *)servicePath request:(id)request completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] patch: servicePath request: request completion: completion];
}

+ (NSProgress *)delete:(NSString *)servicePath request:(id)request completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] delete: servicePath request: request completion: completion];
}

+ (NSProgress *)post:(NSString *)servicePath
           formParts:(NSArray <id <AbstractFormPart>> *)parts
               names:(NSArray <NSString *> *)names
          completion:(ServiceApiResultBlock)completion
{
    return [[self sharedInstance] post: servicePath formParts: parts names: names completion: completion];
}

#pragma mark - Private API

+ (NSString *)requestTransformerName
{
    return [NSStringFromClass(self) stringByAppendingString: @"RequestTransformer"];
}

+ (AbstractServiceApi *)sharedInstance
{
    NSAssert([[self superclass] isSubclassOfClass: [AbstractServiceApi class]], @"Method %@ must be called only from subclasses %@", NSStringFromSelector(_cmd), NSStringFromClass([AbstractServiceApi class]));
    static AbstractServiceApi *sharedService = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //
        sharedService = [[self alloc] init];
    });
    
    return sharedService;
}

- (AFHTTPSessionManager *)sessionManager
{
    [NSException raise: NSGenericException format: @"Method %@ is abstract and must be overrided", NSStringFromSelector(_cmd)];
    return nil;
}

#pragma mark - Internal stuff

- (ServiceApiRequestParameters *)parametersForServicePath:(NSString *)servicePath request:(nullable id)request
{
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName: [self.class requestTransformerName]];
    return [[ServiceApiRequestParameters alloc] initWithURLString: servicePath
                                                       parameters: transformer ? [transformer transformedValue: request] : request];
}

- (SuccessBlock)successBlockForServicePath:(NSString *)servicePath completion:(ServiceApiResultBlock)completion
{
    return completion ? ^(NSURLSessionDataTask *task, id _Nullable responseObject){
        //
        NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName: servicePath];
        id result = transformer ? [transformer transformedValue: responseObject] : responseObject;
        completion(result, nil);
    } : NULL;
}

- (FailureBlock)failureBlockForServicePath:(NSString *)servicePath completion:(ServiceApiResultBlock)completion
{
    return completion ? ^(NSURLSessionDataTask * _Nullable task, NSError *error){
        completion(nil, error);
    } : NULL;
}

- (NSProgress *)post:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;
{
    AFHTTPSessionManager *sessionManager = self.sessionManager;
    
    ServiceApiRequestParameters *parameters = [self parametersForServicePath: servicePath request: request];
    
    NSURLSessionTask *task = [sessionManager POST: parameters.URLString
                                       parameters: parameters.parameters
                                         progress: NULL
                                          success: [self successBlockForServicePath: servicePath completion: completion]
                                          failure: [self failureBlockForServicePath: servicePath completion: completion]];
    
    return [sessionManager uploadProgressForTask: task];
}

- (NSProgress *)get:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;
{
    AFHTTPSessionManager *sessionManager = self.sessionManager;
    
    ServiceApiRequestParameters *parameters = [self parametersForServicePath: servicePath request: request];
    
    NSURLSessionTask *task = [sessionManager GET: parameters.URLString
                                      parameters: parameters.parameters
                                        progress: NULL
                                         success: [self successBlockForServicePath: servicePath completion: completion]
                                         failure: [self failureBlockForServicePath: servicePath completion: completion]];
    
    return [sessionManager downloadProgressForTask: task];
}

- (NSProgress *)put:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;
{
    AFHTTPSessionManager *sessionManager = self.sessionManager;
    
    ServiceApiRequestParameters *parameters = [self parametersForServicePath: servicePath request: request];
    
    NSURLSessionTask *task = [sessionManager PUT: parameters.URLString
                                      parameters: parameters.parameters
                                         success: [self successBlockForServicePath: servicePath completion: completion]
                                         failure: [self failureBlockForServicePath: servicePath completion: completion]];
    
    return [sessionManager uploadProgressForTask: task];
}

- (NSProgress *)patch:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;
{
    AFHTTPSessionManager *sessionManager = self.sessionManager;
    
    ServiceApiRequestParameters *parameters = [self parametersForServicePath: servicePath request: request];
    
    NSURLSessionTask *task = [sessionManager PATCH: parameters.URLString
                                        parameters: parameters.parameters
                                           success: [self successBlockForServicePath: servicePath completion: completion]
                                           failure: [self failureBlockForServicePath: servicePath completion: completion]];
    
    return [sessionManager uploadProgressForTask: task];
}

- (NSProgress *)delete:(NSString *)servicePath request:(nullable id)request completion:(ServiceApiResultBlock)completion;
{
    AFHTTPSessionManager *sessionManager = self.sessionManager;
    
    ServiceApiRequestParameters *parameters = [self parametersForServicePath: servicePath request: request];
    
    NSURLSessionTask *task = [sessionManager DELETE: parameters.URLString
                                         parameters: parameters.parameters
                                            success: [self successBlockForServicePath: servicePath completion: completion]
                                            failure: [self failureBlockForServicePath: servicePath completion: completion]];
    
    return [sessionManager uploadProgressForTask: task];
}

- (NSProgress *)post:(NSString *)servicePath
           formParts:(NSArray <id <AbstractFormPart>> *)parts
               names:(NSArray <NSString *> *)names
          completion:(ServiceApiResultBlock)completion
{
    NSParameterAssert(parts.count == names.count);
    
    AFHTTPSessionManager *sessionManager = self.sessionManager;
    
    NSURLSessionTask *task = [sessionManager POST: servicePath
                                       parameters: nil
                        constructingBodyWithBlock: ^(id<AFMultipartFormData>  _Nonnull formData){
                            //
                            [parts enumerateObjectsUsingBlock: ^(id<AbstractFormPart>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                //
                                NSString *partName = names[idx];
                                
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
                                          success: [self successBlockForServicePath: servicePath completion: completion]
                                          failure: [self failureBlockForServicePath: servicePath completion: completion]];
    
    return [sessionManager uploadProgressForTask: task];
}

@end
