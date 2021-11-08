//
//  DGMapServiceModuleInterface.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <Foundation/Foundation.h>

 
//基础定位类
#import <AMapFoundationKit/AMapFoundationKit.h>
//高德地图基础类
//#import <MAMapKit/MAMapKit.h>
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>
//高德导航类
#import <AMapNaviKit/AMapNaviKit.h>

#import "DGMapViewServiceTypeDefine.h"
#import "DGMapLocationModel.h"

@class CLLocation;
@class AMapPOI;
@class AMapAOI;
/**
 Module interface for the MapService module.
 */
@protocol DGMapServiceModuleInterface <NSObject>

@optional
 
- (UIView*)papredMapViewWithType:(DGMapViewActionType)type;

- (void)searchKeyWord:(NSString *)keyword inCity:(NSString *)city aroundCoordinate:(CLLocationCoordinate2D)coordinate ;

- (void)userChooseAnPOIResult:(AMapAOI *)poi inMapViewWithType:(DGMapViewActionType)type;

- (void)updateCarLocationInMap:(DGMapLocationModel*)carData;

@end

 
/**
 Module delegate for the MapService module.
 */
@protocol DGMapServiceModuleDelegate <NSObject>
@optional

- (void)currentUserLocationData:(DGMapLocationModel*)data;

- (void)currentChoosedLocationData:(DGMapLocationModel*)data;

- (void)userSearchKeyWordsResponse:(AMapPOISearchResponse *)data withType:(DGMapViewActionType)type;

@end
