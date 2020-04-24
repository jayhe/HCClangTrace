//
//  HCViewController.m
//  HCClangTrace
//
//  Created by 贺超 on 04/24/2020.
//  Copyright (c) 2020 贺超. All rights reserved.
//

#import "HCViewController.h"
#import <HCClangTrace/HCClangTrace.h>

@interface HCViewController ()

@end

@implementation HCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HCClangTrace generateOrderFile];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
