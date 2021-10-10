//
//  DGMapServiceView.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <Foundation/Foundation.h>

#import "DGMapViewServiceTypeDefine.h"

/**
 View interface for the MapService module.
 */
@protocol DGMapServiceViewInterface <NSObject>

@optional

- (void)setCenterWithLocation:( CLLocation *)loaction;

- (void)updateMapViewActionType:( DGMapViewActionType )mapViewActionType;

@end
