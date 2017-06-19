//
//  ServiceApiQuery.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 12.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbstractFormPart;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ServiceApiQueryCallback)(id _Nullable resultObject, NSError * _Nullable error);

@interface ServiceApiQuery : NSObject

@property (nonatomic, nullable, readonly) id parameters;

@property (nonatomic, copy, readonly) NSString *URLString;

@property (nonatomic, nullable, strong) NSValueTransformer *responseTransformer;

@property (nonatomic, nullable, copy) ServiceApiQueryCallback callback;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithURLString:(NSString *)URLString parameters:(nullable id)parameters;

- (void)performCallback:(nullable id)object;

@end

@interface ServiceApiMultiPartsQuery : ServiceApiQuery

@property (nonatomic, copy) NSArray <id <AbstractFormPart>> *parts;
@property (nonatomic, copy) NSArray <NSString *> *names;

@end

NS_ASSUME_NONNULL_END