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
@interface MTViewController () <DGMapServiceModuleDelegate>
@property (nonatomic,strong)DGMapModule * mapService ;
@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView * mapView =  [self.mapService.presenter papredMapViewWithType:DGMapViewActionType_UserLocation];
    [self.view addSubview:mapView];
    [mapView setFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height-300 )];
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
//    [self.mapServiceWireframe.presenter requestToChooseEndPoint];
}


- (IBAction)rechooseEnd:(id)sender {
    
}

- (void)mapServiceHasConfirmedUserCity:(NSString *)city {
    NSLog(@"%@",city);
    
}




@end
