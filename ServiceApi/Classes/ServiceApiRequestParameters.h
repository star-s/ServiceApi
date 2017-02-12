//
//  ServiceApiRequestParameters.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 12.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceApiRequestParameters : NSObject

@property (nonatomic, readonly) NSString *URLString;
@property (nonatomic, readonly) id parameters;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithURLString:(NSString *)URLString parameters:(id)parameters;

@end
