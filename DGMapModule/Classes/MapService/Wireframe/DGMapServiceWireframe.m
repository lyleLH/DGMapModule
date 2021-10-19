//
//  DGMapServiceWireframe.m
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import "DGMapServiceWireframe.h"
//#import "DGMapServiceViewController.h"
#import "DGMapView.h"

@interface DGMapServiceWireframe ()

@property (nonatomic, strong) DGMapView *mapView;

@end

@implementation DGMapServiceWireframe

- (void)presentSelfFromViewController:(UIViewController *)viewController
{
    // save reference
    self.mapView = [[DGMapView alloc] init];

    // view <-> presenter
    self.presenter.userInterface = self.mapView;
    self.mapView.eventHandler = self.presenter;

    // present controller
    // *** present self with RootViewController
    [viewController.view addSubview:self.mapView];
    [self.mapView setFrame:CGRectMake(0, 200, viewController.view.bounds.size.width, viewController.view.bounds.size.height - 400)];
//    [self.presenter.interactor prepareSearchServiceWithMapView:self.mapView];
}

@end
