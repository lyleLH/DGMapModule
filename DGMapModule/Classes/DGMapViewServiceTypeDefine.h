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
};

typedef NS_ENUM(NSUInteger, DGMapLocationChooseType) {
    DGMapLocationChooseType_UpdatingUserLocation,
    DGMapLocationChooseType_Start,
    DGMapLocationChooseType_End,
//    DGMapLocationType_poiAroundPoint,
};



#endif /* DGMapViewServiceTypeDefine_h */
