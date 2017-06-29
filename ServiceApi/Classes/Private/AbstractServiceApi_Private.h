//
//  AbstractServiceApi_Private.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 17.06.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <ServiceApi/AbstractServiceApi.h>
#import <ServiceApi/ServiceApiTransport.h>

@class ServiceApiQuery;

NS_ASSUME_NONNULL_BEGIN

@interface AbstractServiceApi () <AbstractService>

@property (nonatomic, nullable, readonly) NSValueTransformer *requestTransformer;

@property (atomic, strong) id <ServiceApiTransport> transport;

@property (nonatomic, getter=isDebug) BOOL debug;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
