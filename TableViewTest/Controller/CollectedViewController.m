//
// Created by 李道政 on 14/11/13.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "CollectedViewController.h"
#import "DetailTableViewController.h"
#import "Shop.h"
#import "ShopCell.h"
#import "BottomCell.h"
#import "Dao.h"
#import "RowObject.h"

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(databaseChangedHandler)
                                                     name:@"DatabaseChanged" object:nil];

    }
    return self;
}

- (void) databaseChangedHandler {

    [self reloadTableView];

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


    [self reloadTableView];
}


- (void) viewDidLoad {
    /*
    * New method for create table view cell
    * https://developer.apple.com/library/ios/documentation/uikit/reference/UITableView_Class/index.html#//apple_ref/occ/instm/UITableView/registerClass:forCellReuseIdentifier:
    * */
    [self.tableView registerClass:[ShopCell class] forCellReuseIdentifier:ReuseIdentifier];
    [self.tableView registerClass:[BottomCell class] forCellReuseIdentifier:BottomCellReuseIdentifier];


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

        [cell updateCell:shop didCollect:YES];
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


- (void) reloadTableView {
    NSLog(@"...reloading...");
//    for (int i = 0; i < [json count]; i++) {
//        [self.tableData addObject:[[Shop alloc] initWithJSON:json[i]]];
//        [self.dao insert:[json[i] objectForKey:@"id"] andJson:json[i]];
//    }
    [self.tableData removeAllObjects];
    NSArray *selectResults = [NSArray arrayWithArray:[self.dao selectAll]];
//    NSLog(@"Dao out, count %i", [selectResults count]);
//    for (int i = 0; i < [selectResults count]; i++) {
//        NSLog(@"id %@ | json %@ | insert time %@", [selectResults[i] id], [selectResults[i] jsonString], [selectResults[i] insert_time]);
//    }

    for (RowObject *row in selectResults) {
//        NSLog(@"id %@ | json %@ | insert time %@", row.id, row.jsonString, row.insert_time);
        NSData *data = [row.jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:nil
                                                               error:nil];
        [self.tableData addObject:[[Shop alloc] initWithJSON:json]];

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
    float reload_distance = 10;
    if (y > h + reload_distance) {
        BottomCell *bottomCell = (BottomCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                                         inSection:BottomSection]];
        NSLog(@"bottomCell...%@", bottomCell);
        [bottomCell addActivityIndicator];

    }
}
@end