//
// Created by 李道政 on 14/10/30.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "TCClient.h"

static NSString *const site = @"http://geekcoffee-staging.roachking.net/api/";
static NSString *const siteArg = @"v1/shops";

static const int SHOP_PAGE_SIZE = 30;

@implementation TCClient

- (void) fetchPage:(int) page completion:(void (^)(NSArray *)) completion {
    NSDictionary *params = @{@"per_page" : @(SHOP_PAGE_SIZE), @"pages" : @(page + 1)};
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [paramString appendFormat:@"%@=%@&", key, obj];
    }];

    NSString *urlString = [NSString stringWithFormat:@"%@%@", site, siteArg];

    if ([paramString length]) {
        urlString = [urlString stringByAppendingFormat:@"?%@", paramString];
    }

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString]
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:2
                                                                                                  error:nil];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    completion(json);
                                                });
                                            }];
    [dataTask resume];
}

@end