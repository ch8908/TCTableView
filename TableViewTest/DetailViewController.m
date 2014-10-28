//
//  DetailViewController.m
//  TableViewTest
//
//  Created by 李道政 on 2014/10/23.
//  Copyright (c) 2014年 李道政. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController()
// make it private, it's safe.
@property (nonatomic, strong) NSNumber *number;
@end

@implementation DetailViewController

// This is designated initializer
- (instancetype) initWithNumber:(NSNumber *) number {
    self = [super init];
    if (self) {
        _number = number;
    }
    return self;
}

- (instancetype) init {
    // All initializer should use designated initializer.
    // if user call init, that's fine, or you can send error message from here.
    return [self initWithNumber:@0];
}

- (void) loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.view =     [[UIView alloc]init];
//    CGRect top;
//    top.origin.x = 0;
//    top.origin.y = 0;
//    top.size.height = 200;
//    top.size.width = 200;
    //NSLog(@"receive string: %@",_data);
    UILabel *label = [[UILabel alloc] init];

    //If you want to use autolayout, must set translatesAutoresizingMaskIntoConstraints to NO.
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"Your data: %@", self.number];
    [self.view addSubview:label];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0]];

    
    
    
//    NSURL *myURL = [[NSURL alloc]initWithString:@"http://geekcoffee-staging.roachking.net/api/v1/shops?per_page=2&page=1"];
//    
//    NSData *myData = [[NSData alloc]initWithContentsOfURL:myURL];
//    
//    NSError *error;
//    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableContainers error:&error];
//    NSLog(@"%@",jsonArray[0][@"id"]);
//    if(!error)
//    {
//        
//        for (id element in jsonArray) {
//            //
//            //textview.text = [NSString stringWithFormat:@"Element: %@",element];
//            NSLog(@"Element: %@",element);
//            
//            // text view will contain last element from the loop
//        }
//    }
//    else{
//        //textview.text = [NSString stringWithFormat:@"Error--%@",[error description]];
//    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
