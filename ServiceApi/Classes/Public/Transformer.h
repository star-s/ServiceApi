//
//  Transformer.h
//  Pods
//
//  Created by Sergey Starukhin on 29.01.18.
//

#import <Foundation/Foundation.h>

@protocol Transformer <NSObject>

- (nullable id)transformedValue:(nullable id)value;

@end

@interface NSValueTransformer (Transformer) <Transformer>
@end
