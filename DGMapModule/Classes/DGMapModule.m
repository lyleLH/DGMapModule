//
//  DGMapModule.m
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import "DGMapModule.h"
//#import "DGMapServiceViewController.h"
#import "DGMapView.h"

@interface DGMapModule ()

@property (nonatomic, strong) DGMapView *mapView;

@end

@implementation DGMapModule


- (instancetype)init {
    if(self ==[super init]){
        DGMapServicePresenter * presenter = [[DGMapServicePresenter alloc] init];
        self.presenter = presenter;
        presenter.mapModule = self;
        
        DGMapServiceInteractor * interactor = [[DGMapServiceInteractor alloc] init];
        
        presenter.interactor = interactor;
        interactor.presenter = presenter;
        
        DGMapServiceDataManager * dataManager = [[DGMapServiceDataManager alloc] init];
        interactor.dataManager = dataManager;
        self.mapView = [[DGMapView alloc] init];

        // view <-> presenter
        self.presenter.userInterface = self.mapView;
        self.mapView.eventHandler = self.presenter;
        
    }
    return self;
}

 

@end
