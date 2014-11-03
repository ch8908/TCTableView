//
//  Shop.h
//  TableViewTest
//
//  Created by 李道政 on 2014/10/28.
//  Copyright (c) 2014年 李道政. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject
@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *isWifiFree;
@property (nonatomic, strong) NSNumber *powerOutlets;
- (instancetype) initWithJSON : (NSDictionary*) json;
@end
