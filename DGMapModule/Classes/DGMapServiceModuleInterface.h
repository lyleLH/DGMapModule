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

@class CLLocation;
@class AMapPOI;
@class AMapAOI;
/**
 Module interface for the MapService module.
 */
@protocol DGMapServiceModuleInterface <NSObject>

@optional
 
- (UIView *) papredMapViewWithType:(DGMapViewActionType  )type;

- (void)userSearchKeyWord:(NSString *)keyword inCity:(NSString *)city aroundCoordinate:(CLLocationCoordinate2D)coordinate ;

- (void)confirmedUserLocationCoordinate:(CLLocationCoordinate2D)coordinate ;


- (void)userDargToNewLocationCoordinate:(CLLocationCoordinate2D)coordinate  ;

- (void)searchRouterWithStartLocation:(CLLocationCoordinate2D)start endLocation:(CLLocationCoordinate2D)end;

- (void)userSelectAPOIPointToShowInMap:(NSDictionary*)poi;

- (void)setMapViewCanBeDrag:(BOOL)canBeDrag ;

@end

 
/**
 Module delegate for the MapService module.
 */
@protocol DGMapServiceModuleDelegate <NSObject>
@optional

- (void)userCurrentLoction:(CLLocationCoordinate2D)location;
- (void)userCurrentLoctionData:(AMapReGeocodeSearchResponse *)data;

- (void)userChoosedLoction:(CLLocationCoordinate2D)location;
- (void)userChoosedLoctionData:(AMapReGeocodeSearchResponse *)data;

- (void)userSearchKeyWordsResponse:(AMapPOISearchResponse *)data;

@end