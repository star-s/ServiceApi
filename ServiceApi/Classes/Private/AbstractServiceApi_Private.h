//
//  AbstractServiceApi_Private.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 17.06.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <ServiceApi/AbstractServiceApi.h>
#import <ServiceApi/ServiceApiTransport.h>
#import <ServiceApi/Transformer.h>

@class ServiceApiQuery;

NS_ASSUME_NONNULL_BEGIN

@interface AbstractServiceApi () <AbstractService>

@property (atomic, strong, nullable) id <Transformer> requestTransformer;

@property (atomic, strong) id <ServiceApiTransport> transport;

@property (nonatomic, getter=isDebug) BOOL debug;

//+ (instancetype)sharedInstance;

- (id <ServiceQuery>)queryWithServicePath:(NSString *)servicePath
                                  request:(nullable id)request
                      responseTransformer:(nullable id <Transformer>)transformer
                               completion:(ServiceApiResultBlock)completion;

- (id <ServiceQuery>)queryWithServicePath:(NSString *)servicePath
                                  request:(nullable id)request
                                formParts:(NSArray <id <AbstractFormPart>> *)parts
                                    names:(NSArray <NSString *> *)names
                      responseTransformer:(nullable id <Transformer>)transformer
                               completion:(ServiceApiResultBlock)completion;

@end

NS_ASSUME_NONNULL_END
