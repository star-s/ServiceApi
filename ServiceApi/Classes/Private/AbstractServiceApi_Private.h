//
//  AbstractServiceApi_Private.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 17.06.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <ServiceApi/AbstractServiceApi.h>

@class ServiceApiQuery;

NS_ASSUME_NONNULL_BEGIN

@interface AbstractServiceApi ()

@property (nonatomic, nullable, readonly) NSValueTransformer *requestTransformer;

@property (nonatomic, getter=isDebug) BOOL debug;

- (instancetype)initWithRequestTransformer:(nullable NSValueTransformer *)transformer NS_DESIGNATED_INITIALIZER;

+ (instancetype)sharedInstance;

- (void)handleResponseObject:(id)responseObject forQuery:(ServiceApiQuery *)query;
- (void)handleError:(NSError *)error forQuery:(ServiceApiQuery *)query;

- (NSProgress *)GET:(ServiceApiQuery *)query;
- (NSProgress *)POST:(ServiceApiQuery *)query;
- (NSProgress *)PUT:(ServiceApiQuery *)query;
- (NSProgress *)PATCH:(ServiceApiQuery *)query;
- (NSProgress *)DELETE:(ServiceApiQuery *)query;

@end

NS_ASSUME_NONNULL_END
