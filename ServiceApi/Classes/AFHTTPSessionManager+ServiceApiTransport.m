//
//  AFHTTPSessionManager+ServiceApiTransport.m
//  ServiceApi
//
//  Created by Sergey Starukhin on 19.06.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "AFHTTPSessionManager+ServiceApiTransport.h"
#import "ServiceApiQuery.h"
#import "ServiceApiFormPartProtocol.h"

typedef void(^SuccessBlock)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

@implementation AFHTTPSessionManager (ServiceApiTransport)

- (NSProgress *)service:(AbstractServiceApi *)service POST:(ServiceApiMultiPartsQuery *)query;
{
    SuccessBlock success = ^(NSURLSessionDataTask *task, id _Nullable responseObject){
        [service handleResponseObject: responseObject forQuery: query];
    };
    FailureBlock failure = ^(NSURLSessionDataTask * _Nullable task, NSError *error){
        [service handleError: error forQuery: query];
    };
    NSURLSessionTask *task = nil;
    
    if ([query isKindOfClass: [ServiceApiMultiPartsQuery class]]) {
        //
        void (^constructorBodyBlock)(id <AFMultipartFormData> formData) = ^(id <AFMultipartFormData> formData){
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
        };
        task = [self POST: query.URLString
               parameters: query.parameters
constructingBodyWithBlock: constructorBodyBlock
                 progress: NULL
                  success: success
                  failure: failure];
    } else {
        task = [self POST: query.URLString
               parameters: query.parameters
                 progress: NULL
                  success: success
                  failure: failure];
    }
    return [self uploadProgressForTask: task];
}

- (NSProgress *)service:(AbstractServiceApi *)service GET:(ServiceApiQuery *)query;
{
    NSURLSessionTask *task = [self GET: query.URLString
                            parameters: query.parameters
                              progress: NULL
                               success: ^(NSURLSessionDataTask *task, id _Nullable responseObject){
                                   [service handleResponseObject: responseObject forQuery: query];
                               }
                               failure: ^(NSURLSessionDataTask * _Nullable task, NSError *error){
                                   [service handleError: error forQuery: query];
                               }];
    
    return [self downloadProgressForTask: task];
}

- (NSProgress *)service:(AbstractServiceApi *)service PUT:(ServiceApiQuery *)query;
{
    NSURLSessionTask *task = [self PUT: query.URLString
                            parameters: query.parameters
                               success: ^(NSURLSessionDataTask *task, id _Nullable responseObject){
                                   [service handleResponseObject: responseObject forQuery: query];
                               }
                               failure: ^(NSURLSessionDataTask * _Nullable task, NSError *error){
                                   [service handleError: error forQuery: query];
                               }];
    
    return [self uploadProgressForTask: task];
}

- (NSProgress *)service:(AbstractServiceApi *)service PATCH:(ServiceApiQuery *)query;
{
    NSURLSessionTask *task = [self PATCH: query.URLString
                              parameters: query.parameters
                                 success: ^(NSURLSessionDataTask *task, id _Nullable responseObject){
                                     [service handleResponseObject: responseObject forQuery: query];
                                 }
                                 failure: ^(NSURLSessionDataTask * _Nullable task, NSError *error){
                                     [service handleError: error forQuery: query];
                                 }];
    
    return [self uploadProgressForTask: task];
}

- (NSProgress *)service:(AbstractServiceApi *)service DELETE:(ServiceApiQuery *)query;
{
    NSURLSessionTask *task = [self DELETE: query.URLString
                               parameters: query.parameters
                                  success: ^(NSURLSessionDataTask *task, id _Nullable responseObject){
                                      [service handleResponseObject: responseObject forQuery: query];
                                  }
                                  failure: ^(NSURLSessionDataTask * _Nullable task, NSError *error){
                                      [service handleError: error forQuery: query];
                                  }];
    
    return [self uploadProgressForTask: task];
}

@end
