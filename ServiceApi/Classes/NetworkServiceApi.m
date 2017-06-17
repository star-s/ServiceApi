//
//  NetworkServiceApi.m
//  ServiceApi
//
//  Created by Sergey Starukhin on 17.06.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "NetworkServiceApi_Private.h"
#import "AbstractServiceApi_Private.h"
#import "ServiceApiFormPartProtocol.h"
#import "ServiceApiQuery.h"

@import AFNetworking;

typedef void(^SuccessBlock)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

@implementation NetworkServiceApi

- (instancetype)init
{
    return [self initWithSessionManager: [AFHTTPSessionManager manager] requestTransformer: nil];
}

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)manager requestTransformer:(NSValueTransformer *)transformer
{
    self = [self initWithRequestTransformer: transformer];
    if (self) {
        _sessionManager = manager;
    }
    return self;
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
    [super setDebug: enable];
}

@end
