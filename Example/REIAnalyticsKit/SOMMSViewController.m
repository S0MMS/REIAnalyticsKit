//
//  SOMMSViewController.m
//  REIAnalyticsKit
//
//  Created by S0MMS on 07/30/2019.
//  Copyright (c) 2019 S0MMS. All rights reserved.
//

#import "SOMMSViewController.h"

@import REIAnalyticsKit;
#import "REIAnalyticsKitHelper.h"

@interface SOMMSViewController ()

@end

@implementation SOMMSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureAnalytics];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // do a simple AB test
    NSString *testName = @"logo";
    NSString *defaultContent = @"red";
    NSDictionary *mboxParameters = @{@"userType":@"Paid"};
    [[REIAnalyticsKitHelper shared] testWithName:testName defaultContent:defaultContent parameters:mboxParameters
                                               callback:^(NSString * _Nullable content) {
                                                   NSLog(@"yeeeah!");
                                               }];
    
}

@end
