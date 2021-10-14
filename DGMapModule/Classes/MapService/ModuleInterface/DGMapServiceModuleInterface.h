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
//拖动地图选到新的的地点，type 起点或终点
- (void)mapviewScrollToANewLoaction:(CLLocation *)location withType:(DGMapViewActionType)type;
//当前定位得到的POI
- (void)mapviewGetUserCurrentLoactionPOIData:(NSDictionary *)poi;
//开始选择起点
- (void)requestToChooseStartPoint;
//开始选择终点
- (void)requestToChooseEndPoint;
//依据搜索结果，更新起点的大头针信息
- (void)updateStartPointWithData:(AMapPOI *)poi  ;

@end

 
/**
 Module delegate for the MapService module.
 */
@protocol DGMapServiceModuleDelegate <NSObject>
@optional
//依据用户定位得到当前的城市信息
- (void)mapServiceHasConfirmedUserCity:(NSString *)city;
//依据选择的定位点 得到的搜索结果列表
- (void)mapServiceLocationPOIResultList:(NSArray *)list;


@end
