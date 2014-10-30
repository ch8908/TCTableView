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

static NSString *const ReuseIdentifier = @"MyIdentifier";

@interface MainViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic) TCClient *client;
@property (nonatomic) int current_page;
@property (nonatomic) BOOL requstingFlag;
@end


//NOTICE VIEWCONTROLLER LIFECYCLE!!
@implementation MainViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        _tableData = [NSMutableArray array];
        _shops = [NSMutableArray array];
        _client = [[TCClient alloc] init];
        _current_page = 0;
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

    //NSNumber* number = @0;
    //[number boolValue];
    /*
    * New method for create table view cell
    * https://developer.apple.com/library/ios/documentation/uikit/reference/UITableView_Class/index.html#//apple_ref/occ/instm/UITableView/registerClass:forCellReuseIdentifier:
    * */
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseIdentifier];
    [self.client fetchPage:0 completion:^(NSArray *json) {
        [self reloadTableView:json];
    }];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [self.tableData count];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    NSString *string = self.tableData[indexPath.row];
    cell.textLabel.text = string;
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *number = self.tableData[indexPath.row];
    //DetailViewController *detailVC = [[DetailViewController alloc] initWithNumber:number];
    DetailTableViewController *detailTVC = [[DetailTableViewController alloc] initWithShop:self.shops[indexPath.row]];
    //[self.navigationController pushViewController:detailVC animated:YES];
    [self.navigationController pushViewController:detailTVC animated:YES];
}

- (void) reloadTableView:(NSArray *) json {
    //Shop *shop1 = [[Shop alloc] initWithJSON:json[0]];
    [self.shops removeAllObjects];
    for (int i = 0; i < [json count]; i++) {
        [self.shops addObject:[[Shop alloc] initWithJSON:json[i]]];
    }
//    for (int i = 0 ; i < [shops count] ; i++){
//        NSLog(@"shop%i id=%@",i+1,[shops[i] shopId]);
//        NSLog(@"shop%i lat=%@",i+1,[shops[i] lat]);
//        NSLog(@"shop%i lng=%@",i+1,[shops[i] lng]);
//        NSLog(@"shop%i name=%@",i+1,[shops[i] name]);
//    }
    //NSLog(@"%@",shop1.shopId);
    //NSLog(@"%@",shop1.powerOutlets);
//    [self.tableData removeAllObjects];
//    for (int i = 0 ; i < [json count] ; i++){
//        //NSLog(@"%@",json[i]);
//        //NSLog(@"element %d :",i);
//        for (id key in json[i]){
//            //NSLog(@"key=%@, value=%@",key,json[i][key]);
//            [self.tableData addObject:key];
//        }
//    }
    for (int i = 0; i < [self.shops count]; i++) {
        [self.tableData addObject:[self.shops[i] name]];
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
        if (self.requstingFlag) {
            return;
        }
        self.requstingFlag = YES;
        int page = ceil(self.tableData.count / (CGFloat) SHOP_PAGE_SIZE);
        [self.client fetchPage:page completion:^(NSArray *json) {
            self.requstingFlag = NO;
            [self reloadTableView:json];
        }];
    }
}


@end
