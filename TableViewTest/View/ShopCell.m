//
// Created by 李道政 on 14/11/11.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "ShopCell.h"
#import "Shop.h"
#import "Dao.h"

NSString *const shopCellReuseIdentifier = @"ShopCell";

@interface ShopCell()
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) Shop *shop;
@property (nonatomic, strong) Dao *dao;
@end

@implementation ShopCell {}

- (instancetype) initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:shopCellReuseIdentifier];
    if (self) {
        _shopNameLabel = [[UILabel alloc] init];
        self.shopNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.shopNameLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.shopNameLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1
                                                                      constant:16]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.shopNameLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];

        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.collectButton setTitle:@"btn" forState:UIControlStateNormal];
//        [self.collectButton setTitle:@"btn" forState:UIControlStateHighlighted];
        [self.collectButton setImage:[UIImage imageNamed:@"collection_button_icon_normal"]
                            forState:UIControlStateNormal];
        [self.collectButton setImage:[UIImage imageNamed:@"collection_button_icon_selected.png"]
                            forState:UIControlStateSelected];
        [self.collectButton.imageView sizeThatFits:CGSizeMake(1, 1)];
        self.collectButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.collectButton];

        NSDictionary *views = @{@"collectButton" : self.collectButton};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[collectButton(==20)]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[collectButton(==20)]-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        //[self.collectButton setSelected:YES];
        [self.collectButton addTarget:self action:@selector(onCollect:)
                     forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.collectButton
//                                                                     attribute:NSLayoutAttributeCenterY
//                                                                     relatedBy:NSLayoutRelationEqual
//                                                                        toItem:self.contentView
//                                                                     attribute:NSLayoutAttributeCenterY
//                                                                    multiplier:1
//                                                                      constant:0]];
    }

    return self;
}

- (void) prepareForReuse {
    [super prepareForReuse];
}

- (void) onCollect:(UIButton *) sender {
    if (1 == sender.state) {
        NSLog(@">>>>>>>>>>>> sender state = %i", sender.state);
        if ([self.delegate respondsToSelector:@selector(didClickCollectCell:button:shop:)]) {
            [self.delegate didClickCollectCell:self button:sender shop:self.shop];
        }
        [sender setSelected:YES];
    }
    else if (5 == sender.state) {
        NSLog(@">>>>>>>>>>>> sender state = %i", sender.state);
        if ([self.delegate respondsToSelector:@selector(didClickSelectedCollectCell:button:shop:)]) {
            [self.delegate didClickSelectedCollectCell:self button:sender shop:self.shop];
        }
        [sender setSelected:NO];
    }
}

- (void) updateCell:(Shop *) shop didCollect:(BOOL) collect {
    self.shop = shop;
    self.shopNameLabel.text = shop.name;
    [self.collectButton setSelected:collect];
}


@end