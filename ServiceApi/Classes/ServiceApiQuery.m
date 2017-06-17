//
//  ServiceApiQuery.m
//  ServiceApi
//
//  Created by Sergey Starukhin on 12.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "ServiceApiQuery.h"

@implementation ServiceApiQuery

- (instancetype)initWithURLString:(NSString *)URLString parameters:(id)parameters
{
    self = [super init];
    if (self) {
        //
        if (URLString && [parameters isKindOfClass: [NSDictionary class]]) {
            //
            NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithString: URLString];
            
            NSString *pathExtension = URLComponents.path.pathExtension;
            
            URLComponents.path = URLComponents.path.stringByDeletingPathExtension;
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: parameters];
            
            NSMutableSet *keysForRemove = [NSMutableSet set];
            
            NSMutableArray <NSString *> *pathComponents = [URLComponents.URL.pathComponents mutableCopy];
            
            [pathComponents enumerateObjectsUsingBlock: ^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //
                if ((obj.length > 1) && [obj hasPrefix: @":"]) {
                    //
                    NSString *key = [obj substringFromIndex: 1];
                    [pathComponents replaceObjectAtIndex: idx withObject: [params[key] description]];
                    [keysForRemove addObject: key];
                }
            }];
            URLComponents.path = [[NSString pathWithComponents: pathComponents] stringByAppendingPathExtension: pathExtension];
            
            [params removeObjectsForKeys: keysForRemove.allObjects];
            
            _parameters = [params copy];
            _URLString = URLComponents.URL.absoluteString;
        } else {
            _parameters = parameters;
            _URLString = URLString;
        }
    }
    return self;
}

- (void)performCallback:(id)object
{
    if (self.callback == nil) {
        return;
    }
    if ([object isKindOfClass: [NSError class]]) {
        self.callback(nil, object);
    } else {
        NSValueTransformer *transformer = self.responseTransformer;
        self.callback((transformer ? [transformer transformedValue: object] : object), nil);
    }
}

@end

@implementation ServiceApiMultiPartsQuery
@end
