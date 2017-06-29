//
//  ServiceApiTransport.h
//  Pods
//
//  Created by Sergey Starukhin on 29.06.17.
//
//

#import <Foundation/Foundation.h>

@protocol AbstractFormPart;

@protocol ServiceQuery <NSObject>

@property (nonatomic, readonly) id parameters;
@property (nonatomic, readonly) NSString *URLString;

@end

@protocol ServiceMultiPartsQuery <ServiceQuery>

@property (nonatomic, readonly) NSArray <id <AbstractFormPart>> *parts;
@property (nonatomic, readonly) NSArray <NSString *> *names;

@end

@protocol AbstractService <NSObject>

- (void)handleResponseObject:(id)responseObject forQuery:(id <ServiceQuery>)query;
- (void)handleError:(NSError *)error forQuery:(id <ServiceQuery>)query;

@end

@protocol ServiceApiTransport <NSObject>

- (NSProgress *)service:(id <AbstractService>)service GET:(id <ServiceQuery>)query;
- (NSProgress *)service:(id <AbstractService>)service POST:(id <ServiceQuery>)query;
- (NSProgress *)service:(id <AbstractService>)service PUT:(id <ServiceQuery>)query;
- (NSProgress *)service:(id <AbstractService>)service PATCH:(id <ServiceQuery>)query;
- (NSProgress *)service:(id <AbstractService>)service DELETE:(id <ServiceQuery>)query;

@end
