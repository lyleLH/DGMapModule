//
//  DGMapServiceViewController.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <UIKit/UIKit.h>

#import "DGMapServiceModuleInterface.h"
#import "DGMapServiceViewInterface.h"

/**
 View controller for the MapService module.
 */
@interface DGMapServiceViewController : UIViewController <DGMapServiceViewInterface>

@property (nonatomic, strong) id<DGMapServiceModuleInterface> eventHandler;

// *** add UI events here

@end
