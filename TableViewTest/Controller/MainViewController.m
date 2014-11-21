//
//  MainViewController.m
//  TableViewTest
//
//  Created by 李道政 on 2014/10/23.
//  Copyright (c) 2014年 李道政. All rights reserved.
//

#import "MainViewController.h"
#import "DetailTableViewController.h"
#import "Shop.h"
#import "TCClient.h"
#import "BottomCell.h"
#import "Dao.h"
#import "RowObject.h"
#import "ShopCell.h"
#import "UIViewController+Bean.h"
#import "Bean.h"

static NSString *const ReuseIdentifier = @"MyIdentifier";

enum {
    ContentsSection = 0,
    BottomSection,
    TotalSection
};

@interface MainViewController()<UITableViewDataSource, UITableViewDelegate, ShopCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *tableData;
//@property (nonatomic, strong) TCClient *client;
//@property (nonatomic, strong) Dao *dao;
@property (nonatomic, assign) BOOL requestingFlag;
@property (nonatomic, strong) NSMutableArray *collectedShopId;
@end


//NOTICE VIEWCONTROLLER LIFECYCLE!!
@implementation MainViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        _tableData = [NSMutableArray array];
//        _client = [[TCClient alloc] init];
        _tableView = [[UITableView alloc] init];
        _refreshControl = [[UIRefreshControl alloc] init];
//        _dao = [Dao sharedDao];
        [self.bean.dao createTable];
//        [_dao createTable];
        _collectedShopId = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDatabaseChangedByCollectedControllerHandler)
                                                     name:@"DatabaseChangedByCollectedController" object:nil];

    }
    return self;
}

- (void) onDatabaseChangedByCollectedControllerHandler {
    NSLog(@">>>>>>>>>>>>> db changed by cvc reloading");
    NSArray *selectResults = [NSArray arrayWithArray:[self.bean.dao selectAll]];
//    NSArray *selectResults = [NSArray arrayWithArray:[self.dao selectAll]];
    [self.collectedShopId removeAllObjects];
    for (RowObject *row in selectResults) {
        [self.collectedShopId addObject:row.id];
        NSLog(@">>>>>>>>>>>> [self.collectedShopId lastObject] = %@", [self.collectedShopId lastObject]);
    }
    [self.tableView reloadData];

}

- (void) loadView {
    UIView *view = [[UIView alloc] init];
    self.view = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    //Layout
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSDictionary *views = @{@"tableView" : self.tableView};
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual toItem:self.view
                                                          attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual toItem:self.view
                                                          attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    NSArray *selectResults = [NSArray arrayWithArray:[self.bean.dao selectAll]];
//    NSArray *selectResults = [NSArray arrayWithArray:[self.dao selectAll]];

    for (RowObject *row in selectResults) {
        [self.collectedShopId addObject:row.id];
    }
}


- (void) viewDidLoad {
    /*
    * New method for create table view cell
    * https://developer.apple.com/library/ios/documentation/uikit/reference/UITableView_Class/index.html#//apple_ref/occ/instm/UITableView/registerClass:forCellReuseIdentifier:
    * */
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(getLatestData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView registerClass:[ShopCell class] forCellReuseIdentifier:ReuseIdentifier];
    [self.tableView registerClass:[BottomCell class] forCellReuseIdentifier:BottomCellReuseIdentifier];


    NSLog(@">>>>>>>>>>>> page = 1");
    [self.bean.client fetchPage:0 completion:^(NSArray *json) {
        [self reloadTableView:json];
    }];
//    [self.client fetchPage:0 completion:^(NSArray *json) {
//        [self reloadTableView:json];
//        //[self.dao insert:<#(NSNumber *)shopId#> andJson:<#(NSArray *)jsonArray#>];
//    }];
}

- (void) getLatestData {
    if (self.requestingFlag) {
        return;
    }
    self.requestingFlag = YES;

    NSLog(@"reloading...");
    [self.bean.client fetchPage:0 completion:^(NSArray *json) {
        self.requestingFlag = NO;
        [self.tableData removeAllObjects];
        for (int i = 0; i < [json count]; i++) {
            [self.tableData addObject:[[Shop alloc] initWithJSON:json[i]]];
        }
        [self.tableView reloadData];
    }];
//    [self.client fetchPage:0 completion:^(NSArray *json) {
//        self.requestingFlag = NO;
//        [self.tableData removeAllObjects];
//        for (int i = 0; i < [json count]; i++) {
//            [self.tableData addObject:[[Shop alloc] initWithJSON:json[i]]];
//        }
//        [self.tableView reloadData];
//    }];
    if (self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = @{NSForegroundColorAttributeName : [UIColor blackColor]};
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title
                                                                              attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;

        [self.refreshControl endRefreshing];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return TotalSection;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if (ContentsSection == section) {
        return [self.tableData count];
    } else if (BottomSection == section) {
        return self.tableData.count > 0 ? 1 : 0;
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    if (ContentsSection == indexPath.section) {
        ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        Shop *shop = self.tableData[indexPath.row];
        [cell updateCell:shop didCollect:[self.collectedShopId containsObject:shop.shopId]];
        return cell;
    }
    else if (BottomSection == indexPath.section) {
        BottomCell *bottomCell = [tableView dequeueReusableCellWithIdentifier:BottomCellReuseIdentifier
                                                                 forIndexPath:indexPath];
        return bottomCell;
    }
    return nil;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailTableViewController *detailTVC = [[DetailTableViewController alloc] initWithShop:self.tableData[indexPath.row]];
    [self.navigationController pushViewController:detailTVC animated:YES];
}

- (void) reloadTableView:(NSArray *) json {
    NSLog(@"...reloading...");
    for (int i = 0; i < [json count]; i++) {
        [self.tableData addObject:[[Shop alloc] initWithJSON:json[i]]];
        //[self.dao insert:[json[i] objectForKey:@"id"] andJson:json[i]];
    }
//    NSArray * selectResults = [[NSArray alloc] initWithArray:[self.dao selectAll]];
//    NSLog(@"%@",selectResults);
//    for(int i = 0 ; i < [selectResults count] ; i++) {
//        NSLog(@"%@,%@,%@", [selectResults[i] id],[selectResults[i] jsonString],[selectResults[i] insert_time]);
//    }
    [self.tableView reloadData];
}

- (void) scrollViewDidScroll:(UIScrollView *) scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
//    NSLog(@"offset: %f", offset.y);
//    NSLog(@"content.height: %f", size.height);
//    NSLog(@"bounds.height: %f", bounds.size.height);
//    NSLog(@"inset.top: %f", inset.top);
//    NSLog(@"inset.bottom: %f", inset.bottom);
//    NSLog(@"pos: %f of %f", y, h);
    float reload_distance = 10;
    if (y > h + reload_distance) {
        if (self.requestingFlag) {
            return;
        }
        BottomCell *bottomCell = (BottomCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                                         inSection:BottomSection]];
        NSLog(@"bottomCell...%@", bottomCell);
        [bottomCell addActivityIndicator];
        self.requestingFlag = YES;
        int page = ceil(self.tableData.count / (CGFloat) SHOP_PAGE_SIZE);
        NSLog(@">>>>>>>>>>>> page = %i", page + 1);
        [self.bean.client fetchPage:page completion:^(NSArray *json) {
            self.requestingFlag = NO;
            [self reloadTableView:json];
        }];
//        [self.client fetchPage:page completion:^(NSArray *json) {
//            self.requestingFlag = NO;
//            [self reloadTableView:json];
//        }];
        //[self.bottomCell.indicatorView stopAnimating];
    }
}

#pragma mark ShopCellDelegate

- (void) didClickCollectCell:(ShopCell *) cell button:(UIButton *) button shop:(Shop *) shop {
    if ([self.collectedShopId containsObject:shop.shopId]) {
        [self.bean.dao delete:shop.shopId];
//        [self.dao delete:shop.shopId];
        [self.collectedShopId removeObject:shop.shopId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DatabaseChanged" object:nil];
        [cell updateCollectState:NO];
    } else {
        [self.bean.dao insert:shop.shopId
                      andJson:@{@"id" : shop.shopId, @"name" : shop.name, @"lat" : shop.lat, @"lng" : shop.lng,
                        @"is_wifi_free" : shop.isWifiFree,
                        @"power_outlets" : shop.powerOutlets}
        ];
//        [self.dao insert:shop.shopId
//                 andJson:@{@"id" : shop.shopId, @"name" : shop.name, @"lat" : shop.lat, @"lng" : shop.lng,
//                   @"is_wifi_free" : shop.isWifiFree,
//                   @"power_outlets" : shop.powerOutlets}
//        ];
        [self.collectedShopId addObject:shop.shopId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DatabaseChanged" object:nil];
        [cell updateCollectState:YES];
    }
}

@end
