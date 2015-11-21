//
//  ViewController.m
//  Addimage
//
//  Created by wangzhen on 15-3-11.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import "ViewController.h"
#import "PickView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PickView* pickV = [[PickView alloc]initWithFrame:CGRectMake(0, 100, 300, 300)];
    
    pickV.dataList = [[NSMutableArray alloc]init];
    pickV.backgroundColor=[UIColor orangeColor];
    
    [self.view addSubview:pickV];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
