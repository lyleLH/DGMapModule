//
//  MTViewController.m
//  DGMapModule
//
//  Created by Tom.Liu on 09/10/2021.
//  Copyright (c) 2021 Tom.Liu. All rights reserved.
//

#import "MTViewController.h"
#import "MTPathViewController.h"
#import "DGMapModule.h"
#import <MJExtension.h>
@interface MTViewController () <DGMapServiceModuleDelegate>
@property (nonatomic,strong)DGMapModule * mapService ;
@property (nonatomic,strong)UIView * mapView;
@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView =  [self.mapService.presenter papredMapViewWithType:DGMapViewActionType_PickStartLocation];
    [self.view addSubview:self.mapView ];
    [self.mapView  setFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height-300 )];
}


- (IBAction)pathRouter:(id)sender {
    MTPathViewController * pathVc = [[MTPathViewController alloc] initWithMapService:self.mapService];
    [self.navigationController pushViewController:pathVc animated:YES];
    
}


- (DGMapModule *)mapService {
    if(!_mapService){
        _mapService = [[DGMapModule alloc] init];
        _mapService.presenter.delegate = self;
    }
    return _mapService;
}



- (IBAction)chooseEnd:(id)sender {
    self.mapView =  [self.mapService.presenter papredMapViewWithType:DGMapViewActionType_PickEndLocation];
}


- (IBAction)rechooseEnd:(id)sender {
    
}

- (void)mapServiceHasConfirmedUserCity:(NSString *)city {
    NSLog(@"%@",city);
    
}


- (void)currentUserLocationData:(DGMapLocationModel *)data {
    NSLog(@"%@",[data mj_keyValues]);
}

- (void)currentChoosedLocationData:(DGMapLocationModel *)data {
    NSLog(@"%@",[data mj_keyValues]);
}



@end
