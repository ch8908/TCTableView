//
// Created by 李道政 on 14/10/30.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TCClient : NSObject
//- (void)fetch:(NSString *)location params:(NSDictionary *)params completion:(void (^)(id,NSError*))completion
- (void) fetchPage:(int) page completion:(void (^)(NSArray *)) completion;
@end
