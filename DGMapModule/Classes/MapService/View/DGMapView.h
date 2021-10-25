//
//  DGMapView.h
//  DGMapModule
//
//  Created by Tom on 2021/10/10.
//

#import <UIKit/UIKit.h>
#import "DGPathRouteMapView.h"


#import "DGMapServiceModuleInterface.h"
#import "DGMapServiceViewInterface.h"

#import "DGMapViewServiceTypeDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface DGMapView : UIView <DGMapServiceViewInterface,AMapSearchDelegate>
@property (nonatomic, strong) id<DGMapServiceModuleInterface> eventHandler;

@property (nonatomic, assign,readonly)  DGMapViewActionType mapViewActionType;;

@end

NS_ASSUME_NONNULL_END
