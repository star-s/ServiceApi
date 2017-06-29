//
//  ServiceApiTransport.h
//  Pods
//
//  Created by Sergey Starukhin on 29.06.17.
//
//

#import <Foundation/Foundation.h>

@class ServiceApiQuery;

@protocol AbstractService <NSObject>

- (void)handleResponseObject:(id)responseObject forQuery:(ServiceApiQuery *)query;
- (void)handleError:(NSError *)error forQuery:(ServiceApiQuery *)query;

@end

@protocol ServiceApiTransport <NSObject>

- (NSProgress *)service:(id <AbstractService>)service GET:(ServiceApiQuery *)query;
- (NSProgress *)service:(id <AbstractService>)service POST:(ServiceApiQuery *)query;
- (NSProgress *)service:(id <AbstractService>)service PUT:(ServiceApiQuery *)query;
- (NSProgress *)service:(id <AbstractService>)service PATCH:(ServiceApiQuery *)query;
- (NSProgress *)service:(id <AbstractService>)service DELETE:(ServiceApiQuery *)query;

@end
