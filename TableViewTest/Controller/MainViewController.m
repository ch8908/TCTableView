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
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) TCClient *client;
//@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) BOOL requestingFlag;
@end


//NOTICE VIEWCONTROLLER LIFECYCLE!!
@implementation MainViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        _tableData = [NSMutableArray array];
        _client = [[TCClient alloc] init];
        _tableView = [[UITableView alloc] init];
        _refreshControl = [[UIRefreshControl alloc] init];
        //_indicatorView = [[UIActivityIndicatorView alloc] init];
    }
    return self;
}

- (void) loadView {
    UIView *view = [[UIView alloc] init];
    self.view = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.tableFooterView = self.indicatorView;
    [self initFooterView];
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
}

- (void) initFooterView {
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actInd.tag = 10;
    actInd.frame = CGRectMake(150.0, 5.0, 20.0, 20.0);
    actInd.hidesWhenStopped = YES;
    [self.footerView addSubview:actInd];
    actInd = nil;

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseIdentifier];
    NSLog(@">>>>>>>>>>>> page = 1");
    [self.client fetchPage:0 completion:^(NSArray *json) {
        [self reloadTableView:json];
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
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;

        [self.refreshControl endRefreshing];
    }
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [self.tableData count];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    Shop *shop = self.tableData[indexPath.row];
    cell.textLabel.text = shop.name;
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailTableViewController *detailTVC = [[DetailTableViewController alloc] initWithShop:self.tableData[indexPath.row]];
    [self.navigationController pushViewController:detailTVC animated:YES];
}

- (void) reloadTableView:(NSArray *) json {
    for (int i = 0; i < [json count]; i++) {
        [self.tableData addObject:[[Shop alloc] initWithJSON:json[i]]];
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
        self.tableView.tableFooterView = self.footerView;
        [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] startAnimating];
        int page = ceil(self.tableData.count / (CGFloat) SHOP_PAGE_SIZE);
        NSLog(@">>>>>>>>>>>> page = %i", page+1);
        [self.client fetchPage:page completion:^(NSArray *json) {
            self.requestingFlag = NO;
            [self reloadTableView:json];
        }];
    }
}

@end
