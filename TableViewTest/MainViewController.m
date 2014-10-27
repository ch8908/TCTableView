//
//  MainViewController.m
//  TableViewTest
//
//  Created by 李道政 on 2014/10/23.
//  Copyright (c) 2014年 李道政. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"

static NSString *const ReuseIdentifier = @"MyIdentifier";

@interface MainViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableData;
@end


//NOTICE VIEWCONTROLLER LIFECYCLE!!
@implementation MainViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        _tableData = [NSMutableArray array];
    }
    return self;
}

- (void) loadView {
    [super loadView];
    //self.view =     [[UIView alloc]init];
    _tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.view addSubview:self.tableView];
    //Layout
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSDictionary* views = @{@"tableView":self.tableView};
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|"
//                                                                          options:0
//                                                                          metrics:nil
//                                                                            views:views]];

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseIdentifier];

    for (int i = 0; i < 99; i++) {
        [self.tableData addObject:[NSNumber numberWithInt:i]];
    }
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [self.tableData count];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    NSNumber *number = self.tableData[indexPath.row];
    cell.textLabel.text = [number stringValue];
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *number = self.tableData[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] initWithNumber:number];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
