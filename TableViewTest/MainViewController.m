//
//  MainViewController.m
//  TableViewTest
//
//  Created by 李道政 on 2014/10/23.
//  Copyright (c) 2014年 李道政. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
@interface MainViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UITableView* tableView;
@property (strong,nonatomic) NSMutableArray* tableData;
@end


//NOTICE VIEWCONTROLLER LIFECYCLE!!
@implementation MainViewController
- (instancetype) init{
    self=[super init];
    if (self){
        _tableData = [NSMutableArray array];
    }
    
    return self;
}

- (void) loadView{
    [super loadView];
    //self.view =     [[UIView alloc]init];
    _tableView=[[UITableView alloc]init ];
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
    
    [self.view addConstraint:    [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [self.view addConstraint:        [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    //Layout
    
    //read object
}

-(void) viewDidLoad{
    //self.tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];

        for(int i = 0 ; i < 99 ; i++){
            [self.tableData addObject:[NSNumber numberWithInt:i]];
        }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 1;
    return [self.tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* MyId=@"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyId];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyId];
    }
    //cell.textLabel.text=@"Hiiii";
    //cell.detailTextLabel.text=@"Huuuue";
    cell.textLabel.text= [[self.tableData objectAtIndex:indexPath.row] stringValue ];
    
    return cell;
    
    //return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES ];
}

@end
