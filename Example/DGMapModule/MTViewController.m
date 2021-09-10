//
//  MTViewController.m
//  DGMapModule
//
//  Created by Tom.Liu on 09/10/2021.
//  Copyright (c) 2021 Tom.Liu. All rights reserved.
//

#import "MTViewController.h"
#import <DGMapModule/DGMapModuleHeader.h>
@interface MTViewController ()

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MapManager *manager = [MapManager sharedManager];
    manager.controller = self;
    [manager initMapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
