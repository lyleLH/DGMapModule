//
//  DGMapSearch.h
//  DGMapModule
//
//  Created by Tom on 2021/9/24.
//

#import <Foundation/Foundation.h>
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>

#import "DGMapModuleServiceProtocol.h"
#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN



@protocol DGMapSearchDelegate <NSObject>

- (void)coordinatePOISearchResult:(AMapPOISearchResponse *)data InRequest:(AMapPOISearchBaseRequest *)request;

- (void)pathSearchResult:(AMapRouteSearchResponse *)response InRequest:(AMapRouteSearchBaseRequest *)request;

@end



@interface DGMapSearch : NSObject <DGMapModuleServiceInterface>
///一个search对象，用于地理位置逆编码
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,weak) id <DGMapSearchDelegate> searchDelegate;

- (instancetype)initWithMapView:(MAMapView *)mapView;

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiWithCenterCoordinate:(CLLocationCoordinate2D )coord  ;

- (void)searchAroundWithKeyWords:(NSString*)keywords  InCity:(NSString*)city andCoordinate:(CLLocationCoordinate2D)coordinate ;

- (void)routeSearchWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end ;
@end

NS_ASSUME_NONNULL_END
