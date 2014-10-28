//
//  Shop.m
//  TableViewTest
//
//  Created by 李道政 on 2014/10/28.
//  Copyright (c) 2014年 李道政. All rights reserved.
//

#import "Shop.h"

@interface Shop()
@property (nonatomic, strong) NSDictionary* jsonElement;
@end

@implementation Shop


- (instancetype) initWithJSON : (NSDictionary*) json{
    for(id key in json){
        if ([key isEqual: @"id"]){
            self.shopId = json[key];
        }
        else if ([key isEqual: @"lat"]){
            self.lat = json[key];
        }
        else if ([key isEqual: @"lng"]){
            self.lng = json[key];
        }
        else if ([key isEqual: @"name"]){
            self.name = json[key];
        }
        else if ([key isEqual: @"is_wifi_free"]){
            self.isWifiFree = json[key];
        }
        else if ([key isEqual: @"power_outlets"]){
            self.powerOutlets = json[key];
        }
    }
    return self;
}
@end