//
//  DGMapServiceView.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <Foundation/Foundation.h>
#import "DGMapViewServiceTypeDefine.h"
 
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>
/**
 View interface for the MapService module.
 */
@protocol DGMapServiceViewInterface <NSObject>

@optional

- (void)setMapViewType:(DGMapViewActionType) type;

- (void)showReGeoSearchResult:(DGMapLocationModel *)model;

- (void)showAnAnnotationWithData:(DGMapLocationModel *)model;

//- (void)showAnPoiPoint:(AMapPOI *)poi;

- (void)showRouterSearchResult:(AMapRouteSearchResponse *)response withStart:(DGMapLocationModel *)start andEnd:(DGMapLocationModel*)end;

- (void)updateCarsLocation:(DGMapLocationModel*)model withFixPoint:(DGMapLocationModel*)point;
@end
