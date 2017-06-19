//
//  AFHTTPSessionManager+ServiceApiTransport.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 19.06.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <ServiceApi/AbstractServiceApi_Private.h>

@interface AFHTTPSessionManager (ServiceApiTransport) <ServiceApiTransport>

@end
