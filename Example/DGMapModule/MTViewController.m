//
//  MTViewController.m
//  DGMapModule
//
//  Created by Tom.Liu on 09/10/2021.
//  Copyright (c) 2021 Tom.Liu. All rights reserved.
//

#import "MTViewController.h"

#import "DGMapModule.h"
@interface MTViewController () <DGMapServiceModuleDelegate>
@property (nonatomic,strong)DGMapModule * mapService ;
@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.mapServiceWireframe presentSelfFromViewController:self];
}
 

- (DGMapModule *)mapServiceWireframe {
    if(!_mapService){
        _mapService = [[DGMapModule alloc] init];
        
        DGMapServicePresenter * presenter = [[DGMapServicePresenter alloc] init];
        _mapService.presenter = presenter;
        presenter.mapModule = _mapService;
        
        presenter.delegate = self;
        DGMapServiceInteractor * interactor = [[DGMapServiceInteractor alloc] init];
        
        presenter.interactor = interactor;
        interactor.presenter = presenter;
        
        DGMapServiceDataManager * dataManager = [[DGMapServiceDataManager alloc] init];
        interactor.dataManager = dataManager;
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
