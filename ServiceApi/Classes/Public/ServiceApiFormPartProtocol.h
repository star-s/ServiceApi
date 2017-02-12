//
//  ServiceApiFormPartProtocol.h
//  ServiceApi
//
//  Created by Sergey Starukhin on 11.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbstractFormPart <NSObject>

@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSString *mimeType;

@end

@protocol DataFormPart <AbstractFormPart>

@property (nonatomic, readonly) NSData *data;

@end

@protocol FileFormPart <AbstractFormPart>

@property (nonatomic, readonly) NSURL *fileURL;

@end

@protocol StreamFormPart <AbstractFormPart>

@property (nonatomic, readonly) NSInputStream *inputStream;
@property (nonatomic, readonly) int64_t inputStreamLength;

@end
