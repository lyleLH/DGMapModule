//
//  DGMapViewServiceTypeDefine.h
//  Pods
//
//  Created by Tom on 2021/10/10.
//

#ifndef DGMapViewServiceTypeDefine_h
#define DGMapViewServiceTypeDefine_h

#import "DGMapLocationModel.h"

typedef NS_ENUM(NSUInteger, DGMapViewActionType) {
    DGMapViewActionType_UserLocation,
    DGMapViewActionType_PickStartLocation,
    DGMapViewActionType_PickEndLocation,
    DGMapViewActionType_ConfirmTwoPoint,
    DGMapViewActionType_WaittingCar,
    DGMapViewActionType_Scheduled,
};




#endif /* DGMapViewServiceTypeDefine_h */
