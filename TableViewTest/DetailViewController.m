//
//  DetailViewController.m
//  TableViewTest
//
//  Created by 李道政 on 2014/10/23.
//  Copyright (c) 2014年 李道政. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
//@property (nonatomic,strong) UIView* view;
@end

@implementation DetailViewController
- (instancetype) init{
    self=[super init];
    if (self){
        
    }    
    return self;
}
- (void) loadView{
    [super loadView];
    self.view.backgroundColor=[UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
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
