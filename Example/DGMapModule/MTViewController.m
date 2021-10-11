//
//  MTViewController.m
//  DGMapModule
//
//  Created by Tom.Liu on 09/10/2021.
//  Copyright (c) 2021 Tom.Liu. All rights reserved.
//

#import "MTViewController.h"
#import <DGMapModule/DGMapModuleHeader.h>
#import "DGMapServiceWireframe.h"

@interface MTViewController () <DGMapServiceModuleDelegate>
@property (nonatomic,strong)DGMapServiceWireframe * mapServiceWireframe;
@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.mapServiceWireframe presentSelfFromViewController:self];
}
 

- (DGMapServiceWireframe *)mapServiceWireframe {
    if(!_mapServiceWireframe){
        _mapServiceWireframe = [[DGMapServiceWireframe alloc] init];
        
        DGMapServicePresenter * presenter = [[DGMapServicePresenter alloc] init];
        _mapServiceWireframe.presenter = presenter;
        presenter.wireframe = _mapServiceWireframe;
        
        presenter.delegate = self;
        DGMapServiceInteractor * interactor = [[DGMapServiceInteractor alloc] init];
        
        presenter.interactor = interactor;
        interactor.presenter = presenter;
        
        DGMapServiceDataManager * dataManager = [[DGMapServiceDataManager alloc] init];
        interactor.dataManager = dataManager;
    }
    return _mapServiceWireframe;
}



- (IBAction)chooseEnd:(id)sender {
    [self.mapServiceWireframe.presenter requestToChooseEndPoint];
}

- (void)mapServiceHasConfirmedUserCity:(NSString *)city {
    NSLog(@"%@",city);
    
}




@end
