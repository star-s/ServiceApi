//
//  AFHTTPSessionManager+ServiceApiTransport.m
//  ServiceApi
//
//  Created by Sergey Starukhin on 19.06.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "AFHTTPSessionManager+ServiceApiTransport.h"
#import "ServiceApiFormPartProtocol.h"

typedef void(^SuccessBlock)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

@implementation AFHTTPSessionManager (ServiceApiTransport)

- (NSProgress *)service:(id <AbstractService>)service POST:(id <ServiceMultiPartsQuery>)query;
{
    SuccessBlock success = ^(NSURLSessionDataTask *task, id _Nullable responseObject){
        [service handleResponseObject: responseObject forQuery: query];
    };
    FailureBlock failure = ^(NSURLSessionDataTask * _Nullable task, NSError *error){
        [service handleError: error forQuery: query];
    };
    NSURLSessionTask *task = nil;
    
    if ([query conformsToProtocol: @protocol(ServiceMultiPartsQuery)]) {
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
        task = [self POST: query.URL.absoluteString
               parameters: query.parameters
constructingBodyWithBlock: constructorBodyBlock
                 progress: NULL
                  success: success
                  failure: failure];
    } else {
        task = [self POST: query.URL.absoluteString
               parameters: query.parameters
                 progress: NULL
                  success: success
                  failure: failure];
    }
    return [self uploadProgressForTask: task];
}

- (NSProgress *)service:(id <AbstractService>)service GET:(id <ServiceQuery>)query;
{
    NSURLSessionTask *task = [self GET: query.URL.absoluteString
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

- (NSProgress *)service:(id <AbstractService>)service PUT:(id <ServiceQuery>)query;
{
    NSURLSessionTask *task = [self PUT: query.URL.absoluteString
                            parameters: query.parameters
                               success: ^(NSURLSessionDataTask *task, id _Nullable responseObject){
                                   [service handleResponseObject: responseObject forQuery: query];
                               }
                               failure: ^(NSURLSessionDataTask * _Nullable task, NSError *error){
                                   [service handleError: error forQuery: query];
                               }];
    
    return [self uploadProgressForTask: task];
}

- (NSProgress *)service:(id <AbstractService>)service PATCH:(id <ServiceQuery>)query;
{
    NSURLSessionTask *task = [self PATCH: query.URL.absoluteString
                              parameters: query.parameters
                                 success: ^(NSURLSessionDataTask *task, id _Nullable responseObject){
                                     [service handleResponseObject: responseObject forQuery: query];
                                 }
                                 failure: ^(NSURLSessionDataTask * _Nullable task, NSError *error){
                                     [service handleError: error forQuery: query];
                                 }];
    
    return [self uploadProgressForTask: task];
}

- (NSProgress *)service:(id <AbstractService>)service DELETE:(id <ServiceQuery>)query;
{
    NSURLSessionTask *task = [self DELETE: query.URL.absoluteString
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
