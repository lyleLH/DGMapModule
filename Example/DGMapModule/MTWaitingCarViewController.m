//
// Created by mttgcc on 11/5/21.
// Copyright (c) 2021 Tom.Liu. All rights reserved.
//

#import "MTWaitingCarViewController.h"



@implementation MTWaitingCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView * mapView = [self.mapService.presenter papredMapViewWithType:DGMapViewActionType_WaittingCar];
    [self.view addSubview:mapView];
    [mapView setFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height-300 )];
    [self.mapService.presenter updateCarLocationInMap:DGMapLocationModel.new];

}


@end