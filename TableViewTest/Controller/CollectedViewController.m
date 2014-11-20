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

- (BOOL) tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *) indexPath {
    return YES;
}

- (void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [self.dao delete:[self.tableData[indexPath.row] shopId]];
        [self.tableData removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        NSArray *selectResults = [NSArray arrayWithArray:[self.dao selectAll]];
        for (RowObject *row in selectResults) {
            NSLog(@"ID = %@", row.id);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DatabaseChangedByCollectedController" object:nil];
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
        Shop *shop = self.tableData[indexPath.row];
        [cell updateCell:shop didCollect:YES];
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


- (void) reloadTableView {
    NSLog(@"...reloading...");
    [self.tableData removeAllObjects];
    NSArray *selectResults = [NSArray arrayWithArray:[self.dao selectAll]];
//    NSLog(@"Dao out, count %i", [selectResults count]);
//    for (int i = 0; i < [selectResults count]; i++) {
//        NSLog(@"id %@ | json %@ | insert time %@", [selectResults[i] id], [selectResults[i] jsonString], [selectResults[i] insert_time]);
//    }

    for (RowObject *row in selectResults) {
        NSData *data = [row.jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:nil
                                                               error:nil];
        [self.tableData addObject:[[Shop alloc] initWithJSON:json]];

    }
    [self.tableView reloadData];
}
@end