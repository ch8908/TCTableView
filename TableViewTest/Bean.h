//
// Created by 李道政 on 14/11/20.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Dao;
@class TCClient;


@interface Bean : NSObject

@property (nonatomic, strong) Dao *dao;
@property (nonatomic, strong) TCClient *client;

+ (id) sharedInstance;
@end