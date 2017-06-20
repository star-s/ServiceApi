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

@protocol ServiceApiTransport <NSObject>

- (NSProgress *)service:(AbstractServiceApi *)service GET:(ServiceApiQuery *)query;
- (NSProgress *)service:(AbstractServiceApi *)service POST:(ServiceApiQuery *)query;
- (NSProgress *)service:(AbstractServiceApi *)service PUT:(ServiceApiQuery *)query;
- (NSProgress *)service:(AbstractServiceApi *)service PATCH:(ServiceApiQuery *)query;
- (NSProgress *)service:(AbstractServiceApi *)service DELETE:(ServiceApiQuery *)query;

@end

@interface AbstractServiceApi ()

@property (nonatomic, nullable, readonly) NSValueTransformer *requestTransformer;

@property (atomic, strong) id <ServiceApiTransport> transport;

@property (nonatomic, getter=isDebug) BOOL debug;

+ (instancetype)sharedInstance;

- (void)handleResponseObject:(id)responseObject forQuery:(ServiceApiQuery *)query;
- (void)handleError:(NSError *)error forQuery:(ServiceApiQuery *)query;

@end

NS_ASSUME_NONNULL_END
