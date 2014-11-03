//
// Created by 李道政 on 14/11/3.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FooterView : UIView
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (instancetype) initFooterViewWithFrame:(CGRect) frame;
@end