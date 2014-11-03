//
// Created by 李道政 on 14/11/3.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

- (instancetype) initFooterViewWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.backgroundColor = [UIColor blueColor];
        [self.indicatorView startAnimating];
        [self addSubview:self.indicatorView];
    }
    return self;
}

@end