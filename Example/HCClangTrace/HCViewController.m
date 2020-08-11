//
//  HCViewController.m
//  HCClangTrace
//
//  Created by 贺超 on 04/24/2020.
//  Copyright (c) 2020 贺超. All rights reserved.
//

#import "HCViewController.h"
#import <HCClangTrace/HCClangTrace.h>
#import <AFNetworking/AFNetworking.h>
#import "HCClangTrace_Example-Swift.h"

void testCallCMethod(void);

@interface HCViewController ()

@property (nonatomic, copy) void(^testCallBlock)(void);

@end

@implementation HCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.testCallBlock = ^(void){
        NSLog(@"testCallBlock");
    };
    [self callSomeMethods];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HCClangTrace generateOrderFile];
    });
    /*
     输出如下：
     _main
     -[HCAppDelegate window]
     -[HCAppDelegate setWindow:]
     -[HCAppDelegate application:didFinishLaunchingWithOptions:]
     -[HCViewController viewDidLoad]
     -[HCViewController setTestCallBlock:]
     -[HCViewController callSomeMethods]
     +[AFNetworkReachabilityManager sharedManager]
     ___45+[AFNetworkReachabilityManager sharedManager]_block_invoke
     +[AFNetworkReachabilityManager manager]
     +[AFNetworkReachabilityManager managerForAddress:]
     -[AFNetworkReachabilityManager initWithReachability:]
     -[AFNetworkReachabilityManager setNetworkReachabilityStatus:]
     -[AFNetworkReachabilityManager startMonitoring]
     -[AFNetworkReachabilityManager stopMonitoring]
     -[AFNetworkReachabilityManager networkReachability]
     ___copy_helper_block_e8_32w
     _AFNetworkReachabilityRetainCallback
     ___copy_helper_block_e8_32s40b
     -[HCViewController testCallBlock]
     ___31-[HCViewController viewDidLoad]_block_invoke
     _testCallCMethod
     -[HCAppDelegate applicationDidBecomeActive:]
     -[HCViewController viewDidAppear:]
     ___34-[HCViewController viewDidAppear:]_block_invoke
     */
}

#pragma mark - Private Method

- (void)callSomeMethods {
    // call third lib method
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // call block
    self.testCallBlock();
    // call swift method
    [[TestCallSwift new] testCallSwiftMethod];
    // call c method
    testCallCMethod();
}

@end

void testCallCMethod(void) {
    NSLog(@"testCallCMethod");
}
