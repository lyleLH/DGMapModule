//
//  MTPathViewController.m
//  DGMapModule_Example
//
//  Created by Tom on 2021/10/25.
//  Copyright © 2021 Tom.Liu. All rights reserved.
//

#import "MTPathViewController.h"
#import "MTWaitingCarViewController.h"
@interface MTPathViewController ()
@property (nonatomic,strong)DGMapModule * mapService ;
@end

@implementation MTPathViewController


- (instancetype)initWithMapService:(DGMapModule *)mapService {
    if(self == [super init]){
        _mapService = mapService;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView * mapView =  [self.mapService.presenter papredMapViewWithType:DGMapViewActionType_ConfirmTwoPoint];
    [self.view addSubview:mapView];
    [mapView setFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height-300 )];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton * wattingButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, 50, 44)];
    [wattingButton setTitle:@"等车" forState:UIControlStateNormal];
    [wattingButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [wattingButton addTarget:self action:@selector(waittingCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wattingButton];
}


- (void)waittingCar {
    MTWaitingCarViewController * vc = [[MTWaitingCarViewController alloc] init];
    vc.mapService = self.mapService;
    [self.navigationController pushViewController:vc animated:YES];
}
 

@end
