//
// Created by 李道政 on 14/11/3.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "FooterView.h"


@implementation FooterView

+ (UIView *) initFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actInd.tag = 10;
    actInd.frame = CGRectMake(150.0, 5.0, 20.0, 20.0);
    actInd.hidesWhenStopped = YES;
    [footerView addSubview:actInd];
    actInd = nil;
    return footerView;
}

+ (void) startAnimation : (UIView *) footerView{
    [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
}

@end