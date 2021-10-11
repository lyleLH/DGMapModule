//
//  DGMapServiceModuleInterface.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <Foundation/Foundation.h>

#import "DGMapViewServiceTypeDefine.h"

@class CLLocation;
@class AMapPOI;
/**
 Module interface for the MapService module.
 */
@protocol DGMapServiceModuleInterface <NSObject>

@optional
///地图视图事件
///得到用户的当前定位信息
- (void)mapviewGetUserCurrentLoaction:(CLLocation *)location;

- (void)mapviewScrollToANewLoaction:(CLLocation *)location withType:(DGMapViewActionType)type;

- (void)mapviewGetUserCurrentLoactionPOIData:(NSDictionary *)poi;

- (void)requestToChooseStartPoint;

- (void)requestToChooseEndPoint;
//更新起点的大头针信息
- (void)updateStartPointWithData:(AMapPOI *)poi  ;

@end

 
/**
 Module delegate for the MapService module.
 */
@protocol DGMapServiceModuleDelegate <NSObject>

- (void)mapServiceHasConfirmedUserCity:(NSString *)city;
- (void)mapServiceLocationPOIResultList:(NSArray *)list;


@end
