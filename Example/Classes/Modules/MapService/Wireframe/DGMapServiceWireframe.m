//
//  DGMapServiceWireframe.m
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import "DGMapServiceWireframe.h"
#import "DGMapServiceViewController.h"

@interface DGMapServiceWireframe ()

@property (nonatomic, strong) DGMapServiceViewController *viewController;

@end

@implementation DGMapServiceWireframe

- (void)presentSelfFromViewController:(UIViewController *)viewController
{
    // save reference
    self.viewController = [[DGMapServiceViewController alloc] initWithNibName:@"DGMapServiceViewController" bundle:nil];

    // view <-> presenter
    self.presenter.userInterface = self.viewController;
    self.viewController.eventHandler = self.presenter;

    // present controller
    // *** present self with RootViewController
}

@end
