//
// Created by 李道政 on 14/11/13.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "CollectedViewController.h"
#import "DetailTableViewController.h"
#import "Dao.h"

static NSString *const ReuseIdentifier = @"MyIdentifier";

enum {
    ContentsSection = 0,
    BottomSection,
    TotalSection
};

@interface CollectedViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) Dao *dao;
@end

@implementation CollectedViewController {

}

- (instancetype) init {
    self = [super init];
    if (self) {
        _tableData = [NSMutableArray array];
        _tableView = [[UITableView alloc] init];
        _dao = [[Dao alloc] initWithDatabaseName:@"db.sqlite"];
        [_dao createTable];

    }
    return self;
}

- (void) loadView {
    UIView *view = [[UIView alloc] init];
    self.view = view;
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
    [self.client fetchPage:0 completion:^(NSArray *json) {
        [self reloadTableView:json];
        //[self.dao insert:<#(NSNumber *)shopId#> andJson:<#(NSArray *)jsonArray#>];
    }];
}

- (void) getLatestData {
    if (self.requestingFlag) {
        return;
    }
    self.requestingFlag = YES;

    NSLog(@"reloading...");
    [self.client fetchPage:0 completion:^(NSArray *json) {
        self.requestingFlag = NO;
        [self.tableData removeAllObjects];
        for (int i = 0; i < [json count]; i++) {
            [self.tableData addObject:[[Shop alloc] initWithJSON:json[i]]];
        }
        [self.tableView reloadData];
    }];
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
    if (indexPath.section == ContentsSection) {

//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
        ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier
                                                         forIndexPath:indexPath];
        Shop *shop = self.tableData[indexPath.row];
        [cell insertData:shop];
//        cell.textLabel.text = shop.name;
        return cell;
    }
    else if (indexPath.section == BottomSection) {
        BottomCell *bottomCell = [tableView dequeueReusableCellWithIdentifier:BottomCellReuseIdentifier
                                                                 forIndexPath:indexPath];
        NSLog(@"Bottom cell initialized");

        return bottomCell;
    }
    return nil;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailTableViewController *detailTVC = [[DetailTableViewController alloc] initWithShop:self.tableData[indexPath.row]];
    [self.navigationController pushViewController:detailTVC animated:YES];
}

//- (CGFloat) tableView:(UITableView *) tableView heightForFooterInSection:(NSInteger) section {
//    return 80;
//}
//
//- (UIView *) tableView:(UITableView *) tableView viewForFooterInSection:(NSInteger) section {
//    return [[FooterView alloc] initFooterViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80)];
//}

- (void) reloadTableView:(NSArray *) json {
    NSLog(@"...reloading...");
    for (int i = 0; i < [json count]; i++) {
        [self.tableData addObject:[[Shop alloc] initWithJSON:json[i]]];
        [self.dao insert:[json[i] objectForKey:@"id"] andJson:json[i]];
    }
    NSArray * selectResults = [[NSArray alloc] initWithArray:[self.dao selectAll]];
    NSLog(@"%@",selectResults);
    for(int i = 0 ; i < [selectResults count] ; i++) {
        NSLog(@"%@,%@,%@", [selectResults[i] id],[selectResults[i] jsonString],[selectResults[i] insert_time]);
    }
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
        [self.client fetchPage:page completion:^(NSArray *json) {
            self.requestingFlag = NO;
            [self reloadTableView:json];
        }];
        //[self.bottomCell.indicatorView stopAnimating];
    }
}
@end