//
//  ServiceApiQuery.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 12.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ServiceApi/ServiceApiTransport.h>

@protocol AbstractFormPart, Transformer;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ServiceApiQueryCallback)(id _Nullable resultObject, NSError * _Nullable error);

@interface ServiceApiQuery : NSObject <ServiceQuery>

@property (nonatomic, nullable, strong) id parameters;

@property (nonatomic, nullable, copy) NSString *URLString;

@property (nonatomic, nullable, strong) id <Transformer> responseTransformer;

@property (nonatomic, nullable, copy) ServiceApiQueryCallback callback;

- (void)performCallback:(nullable id)object;

@end

@interface ServiceApiMultiPartsQuery : ServiceApiQuery <ServiceMultiPartsQuery>

@property (nonatomic, strong) NSArray <id <AbstractFormPart>> *parts;
@property (nonatomic, strong) NSArray <NSString *> *names;

@end

NS_ASSUME_NONNULL_END
