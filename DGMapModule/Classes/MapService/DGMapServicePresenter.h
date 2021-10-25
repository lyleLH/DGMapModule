//
//  DGMapServicePresenter.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <Foundation/Foundation.h>
 
#import "DGMapServiceModuleInterface.h"

#import "DGMapServiceInteractor.h"
 
#import "DGMapServiceViewInterface.h"

#import "DGLocationChooseMapView.h"

@class DGMapServiceWireframe;
@class DGMapServiceInteractor;
@class DGMapModule;
/**
 Display logic for the MapService module.
 */
@interface DGMapServicePresenter : NSObject <DGMapServiceModuleInterface,AMapSearchDelegate,DGLocationChooseMapViewDelegate>

@property (nonatomic, strong) DGMapServiceInteractor *interactor;
@property (nonatomic, weak) DGMapModule * mapModule;

@property (nonatomic, weak) UIView<DGMapServiceViewInterface> *userInterface;

@property (nonatomic, weak) id<DGMapServiceModuleDelegate> delegate;

@end
