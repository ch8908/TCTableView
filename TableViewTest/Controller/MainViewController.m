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
@end


//NOTICE VIEWCONTROLLER LIFECYCLE!!
@implementation MainViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        _tableData = [NSMutableArray array];
        _shops = [NSMutableArray array];
        _client = [[TCClient alloc] init];
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
    [self.client fetchStoresWithCompletion:^(NSArray *json) {
        [self reloadTableView:json];
    }];


    /*NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = @"http://geekcoffee-staging.roachking.net/api/v1/shops?per_page=10&page=1";
    //NSString *urlString = @"http://go.redirectingat.com/?id=1342X589339&site=code.tutsplus.com&xs=1&isjs=1&url=https%3A%2F%2Fitunes.apple.com%2Fsearch%3Fterm%3Dapple%26media%3Dsoftware&xguid=3f7ae087b8c9cff96b4c549b7f227dc9&xcreo=0&xed=0&sref=http%3A%2F%2Fcode.tutsplus.com%2Ftutorials%2Fnetworking-with-nsurlsession-part-1--mobile-21394&pref=https%3A%2F%2Fwww.google.com.tw%2F&xtz=-480";
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:2 error:nil];
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:2 error:nil];

        dispatch_async(dispatch_get_main_queue(), ^{
            //UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
//            UILabel *jsonLabel = [[UILabel alloc] init];
//            jsonLabel.translatesAutoresizingMaskIntoConstraints = NO;
//            jsonLabel.textAlignment = NSTextAlignmentCenter;
//            jsonLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];

            //            for(id key in json){
            //                //NSLog(@"key=%@,value=%@", key, [json objectForKey:key]);
            //                NSLog(@"key=%@",[[key stringValue]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
            //
            //                //jsonLabel.text = [key stringValue];
            //
            //            }
            //jsonLabel.text = json; // or whatever you wanted from `skillData`
            //[self.view addSubview:jsonLabel];

            [self reloadTableView:json];

        });
    }];
    [dataTask resume];*/
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
    [self.tableData removeAllObjects];
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


@end
