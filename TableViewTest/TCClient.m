//
// Created by 李道政 on 14/10/30.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "TCClient.h"


@implementation TCClient
- (void) fetchStoresWithCompletion:(void (^)(NSArray *)) completion {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = @"http://geekcoffee-staging.roachking.net/api/v1/shops?per_page=10&page=1";
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString]
                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:2 error:nil];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                    completion(json);
                            });
    }];
    [dataTask resume];
}
@end