//
//  DGMapServiceView.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <Foundation/Foundation.h>

 
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>
/**
 View interface for the MapService module.
 */
@protocol DGMapServiceViewInterface <NSObject>

@optional

//显示用户自身位置的搜索结果、显示用户拖动选点的搜索结果
 
- (void)showReGeoSearchResult:(AMapReGeocodeSearchResponse *)response;

- (void)showAnPoiPoint:(AMapPOI *)poi;

- (void)showRouterSearchResult:(AMapRouteSearchResponse *)response;

- (void)setMapViewCanBeDrag:(BOOL)canBeDrag ;

@end
