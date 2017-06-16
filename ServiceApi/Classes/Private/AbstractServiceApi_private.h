//
//  AbstractServiceApi_private.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 11.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <ServiceApi/AbstractServiceApi.h>

@class AFHTTPSessionManager, ServiceApiQuery;

NS_ASSUME_NONNULL_BEGIN

@interface AbstractServiceApi ()

@property (nonatomic, readonly) __kindof AFHTTPSessionManager *sessionManager;

@property (nonatomic, readonly) NSValueTransformer *requestTransformer;

@property (nonatomic, getter=isDebug) BOOL debug;

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)manager
                    requestTransformer:(NSValueTransformer *)transformer NS_DESIGNATED_INITIALIZER;

+ (instancetype)sharedInstance;

- (ServiceApiQuery *)queryWithServicePath:(NSString *)servicePath
                                  request:(nullable id)request
                               completion:(ServiceApiResultBlock)completion;

- (ServiceApiQuery *)queryWithServicePath:(NSString *)servicePath
                                formParts:(NSArray <id <AbstractFormPart>> *)parts
                                    names:(NSArray <NSString *> *)names
                               completion:(ServiceApiResultBlock)completion;

- (void)handleResponseObject:(id)responseObject forQuery:(ServiceApiQuery *)query;
- (void)handleError:(NSError *)error forQuery:(ServiceApiQuery *)query;

- (NSProgress *)GET:(ServiceApiQuery *)query;
- (NSProgress *)POST:(ServiceApiQuery *)query;
- (NSProgress *)PUT:(ServiceApiQuery *)query;
- (NSProgress *)PATCH:(ServiceApiQuery *)query;
- (NSProgress *)DELETE:(ServiceApiQuery *)query;

@end

NS_ASSUME_NONNULL_END
