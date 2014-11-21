//
// Created by 李道政 on 14/11/20.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "Bean.h"
#import "Dao.h"
#import "TCClient.h"

@implementation Bean {

}

+ (id) sharedInstance {
    static Bean *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    return sharedMyInstance;
}

- (id) init {
    self = [super init];
    if (self) {
        _dao = [[Dao alloc] initWithDatabaseName:@"db.sqlite"];
        _client = [[TCClient alloc] init];
    }
    return self;
}

@end