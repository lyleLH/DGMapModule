//
//  DGMapServiceWireframe.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <Foundation/Foundation.h>

#import "RootWireframe.h"
#import "DGMapServicePresenter.h"

@class DGMapServicePresenter;

/**
 Module wireframe for the MapService module.
 */
@interface DGMapServiceWireframe : NSObject

@property (nonatomic, strong) RootWireframe *rootWireframe;
@property (nonatomic, strong) DGMapServicePresenter *presenter;

// initialization
- (void)presentSelfFromViewController:(UIViewController *)viewController;

@end
