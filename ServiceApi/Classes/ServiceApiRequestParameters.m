//
//  ServiceApiRequestParameters.m
//  ServiceApi
//
//  Created by Sergey Starukhin on 12.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "ServiceApiRequestParameters.h"

@implementation ServiceApiRequestParameters

- (instancetype)initWithURLString:(NSString *)URLString parameters:(id)parameters
{
    self = [super init];
    if (self) {
        //
        if (URLString && [parameters isKindOfClass: [NSDictionary class]]) {
            //
            NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithString: URLString];
            
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
            URLComponents.path = [NSString pathWithComponents: pathComponents];
            
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

@end
