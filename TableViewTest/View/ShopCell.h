//
// Created by 李道政 on 14/11/11.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Shop;
@class ShopCell;

@protocol ShopCellDelegate<NSObject>
- (void) didClickCollectCell:(ShopCell *) cell button:(UIButton *) button shop:(Shop *) shop;
@end

@interface ShopCell : UITableViewCell
@property (nonatomic, strong) id<ShopCellDelegate> delegate;

- (instancetype) initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier;

- (void) updateCell:(Shop *) shop didCollect:(BOOL) collect;

- (void) updateCollectState:(BOOL) b;
@end