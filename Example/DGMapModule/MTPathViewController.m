//
//  MTPathViewController.m
//  DGMapModule_Example
//
//  Created by Tom on 2021/10/25.
//  Copyright © 2021 Tom.Liu. All rights reserved.
//

#import "MTPathViewController.h"

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIView * mapView =  [self.mapService.presenter papredMapViewWithType:DGMapViewActionType_ConfirmTwoPoint];
    [self.view addSubview:mapView];
    [mapView setFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height-300 )];

}

 

@end
