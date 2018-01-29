//
//  ServiceApiQuery.m
//  ServiceApi
//
//  Created by Sergey Starukhin on 12.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "ServiceApiQuery.h"
#import <ServiceApi/Transformer.h>

@implementation ServiceApiQuery

- (void)performCallback:(id)object
{
    if (self.callback == nil) {
        return;
    }
    if ([object isKindOfClass: [NSError class]]) {
        self.callback(nil, object);
    } else if (self.responseTransformer) {
        self.callback([self.responseTransformer transformedValue: object], nil);
    } else {
        self.callback(object, nil);
    }
}

- (NSURL *)URL
{
    return [NSURL URLWithString: self.URLString];
}

@end

@implementation ServiceApiMultiPartsQuery
@end
