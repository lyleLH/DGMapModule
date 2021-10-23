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
    [self.mapView setFrame:CGRectMake(0, 0, viewController.view.bounds.size.width, viewController.view.bounds.size.height )];
//    [self.presenter.interactor prepareSearchServiceWithMapView:self.mapView];
}

@end
