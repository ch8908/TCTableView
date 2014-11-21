//
// Created by 李道政 on 14/11/20.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "UIViewController+Bean.h"
#import "Bean.h"

@implementation UIViewController(Bean)
- (Bean *) bean {
    return [Bean sharedInstance];
}

@end