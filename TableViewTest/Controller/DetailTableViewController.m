//
//  DetailTableViewController.m
//  TableViewTest
//
//  Created by 李道政 on 2014/10/28.
//  Copyright (c) 2014年 李道政. All rights reserved.
//

#import "DetailTableViewController.h"
#import "Shop.h"


static NSString *const ReuseIdentifier = @"MyIdentifier";

enum {
    ShopIdSection = 0,
    ShopNameSection,
    ShopLatSection,
    ShopLngSection,
    ShopWifiFreeSetion,
    ShopPowerOutletSection,
    TotalSection
};

@interface DetailTableViewController()<UITableViewDataSource, UITableViewDelegate>;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *shopInfo;
@property (nonatomic, strong) Shop *shop;
@end

@implementation DetailTableViewController

- (instancetype) initWithShop:(Shop *) shop {
    self = [super init];
    if (self) {
        _shopInfo = [NSMutableArray array];
        _shop = shop;
    }
    return self;
}

- (void) loadView {
    UIView *view = [[UIView alloc] init];
    self.view = view;
    _tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual toItem:self.view
                                                          attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual toItem:self.view
                                                          attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
}

- (void) viewDidLoad {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseIdentifier];
    [super viewDidLoad];
    [self.shopInfo addObject:self.shop.shopId];
    [self.shopInfo addObject:self.shop.name];
    [self.shopInfo addObject:self.shop.lat];
    [self.shopInfo addObject:self.shop.lng];
    [self.shopInfo addObject:self.shop.isWifiFree];
    [self.shopInfo addObject:self.shop.powerOutlets];
    //NSLog(@"%@//%@//%i",self.shop.name,self.shopInfo,[self.shopInfo count]);
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return TotalSection;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    //NSLog(@"%@",[self.shopInfo[indexPath.row] stringValue]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    //NSString *string = self.shopInfo[indexPath.row];
    //NSLog(@"%i",indexPath.section);
    switch (indexPath.section) {
        case ShopIdSection: {
            NSNumber *number = self.shopInfo[indexPath.section];
            cell.textLabel.text = [number stringValue];
            break;
        }
        case ShopNameSection: {
            cell.textLabel.text = self.shopInfo[indexPath.section];
            break;
        }
        case ShopLatSection: {
            NSNumber *number = self.shopInfo[indexPath.section];
            cell.textLabel.text = [number stringValue];
            break;
        }
        case ShopLngSection: {
            NSNumber *number = self.shopInfo[indexPath.section];
            cell.textLabel.text = [number stringValue];
            break;
        }
        case ShopWifiFreeSetion: {
            NSNumber *number = self.shopInfo[indexPath.section];
            cell.textLabel.text = [number stringValue];
            break;
        }
        case ShopPowerOutletSection: {
            NSNumber *number = self.shopInfo[indexPath.section];
            cell.textLabel.text = [number stringValue];
            break;
        }
        default:
            break;
    }
    return cell;
}

@end
