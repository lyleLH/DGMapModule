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
#import "DGMapServiceWireframe.h"
#import "DGMapServiceViewInterface.h"

@class DGMapServiceWireframe;
@class DGMapServiceInteractor;

/**
 Display logic for the MapService module.
 */
@interface DGMapServicePresenter : NSObject <DGMapServiceModuleInterface>

@property (nonatomic, strong) DGMapServiceInteractor *interactor;
@property (nonatomic, weak) DGMapServiceWireframe *wireframe;

@property (nonatomic, weak) UIView<DGMapServiceViewInterface> *userInterface;

@property (nonatomic, weak) id<DGMapServiceModuleDelegate> delegate;

@end
