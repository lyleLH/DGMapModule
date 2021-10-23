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


@class CLLocation;
@class AMapPOI;
@class AMapAOI;
/**
 Module interface for the MapService module.
 */
@protocol DGMapServiceModuleInterface <NSObject>

@optional
 
- (void)userSearchKeyWord:(NSString *)keyword inCity:(NSString *)city aroundCoordinate:(CLLocationCoordinate2D)coordinate ;

- (void)confirmedUserLocationCoordinate:(CLLocationCoordinate2D)coordinate ;


- (void)userDargToNewLocationCoordinate:(CLLocationCoordinate2D)coordinate  ;


@end

 
/**
 Module delegate for the MapService module.
 */
@protocol DGMapServiceModuleDelegate <NSObject>
@optional

- (void)userCurrentLoctionData:(AMapReGeocodeSearchResponse *)data;
- (void)userChoosedLoctionData:(AMapReGeocodeSearchResponse *)data;
- (void)userSearchKeyWordsResponse:(AMapPOISearchResponse *)data;

@end
