//
//  DGMapServiceInteractor.m
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import "DGMapServiceInteractor.h"
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>

 
#import <AMapNaviKit/AMapNaviKit.h>


@interface DGMapServiceInteractor () <AMapSearchDelegate>


@end

@implementation DGMapServiceInteractor



- (instancetype)init {
    if(self =[super init]){
        
    }
    return self;
}

#pragma mark -- 路径搜索
- (void)routeSearchWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end {
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
//    navi.destinationId = @"BV10001595";
//    navi.destinationtype = @"150500";
    navi.strategy = 10;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:start.latitude
                                           longitude:start.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:end.latitude
                                                longitude:end.longitude];
    
    [self.search AMapDrivingRouteSearch:navi];
}


#pragma mark -- 兴趣点POI搜索

- (void)searchAroundWithKeyWords:(NSString*)keywords  InCity:(NSString*)city andCoordinate:(CLLocationCoordinate2D)coordinate {
    
    AMapPOIAroundSearchRequest  *request=[[AMapPOIAroundSearchRequest alloc] init];
//    AMapPOIKeywordsSearchRequest  *request= [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.radius = 10000;
    request.city = city;
    request.location=[AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.keywords = keywords;
    [self.search AMapPOIAroundSearch:request];
//    [self.search AMapPOIKeywordsSearch:request];
}


#pragma mark -- 逆地理搜索

-(void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate isUserLocation:(BOOL)isUseLocation {
   
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    regeo.radius = 200;
    [self.search AMapReGoecodeSearch:regeo];
}

#pragma mark -- AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"💥💥💥💥 %@",error);
    [self.presenter AMapSearchRequest:request didFailWithError:error];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
//    if(self.dataManager.isGettingUserLocationSearchResult){
//        [self.dataManager saveUserLocationSearchResult:response];
//        self.dataManager.isGettingUserLocationSearchResult = NO;
//    }else{
//        [self.dataManager saveChoosedLocationSearchResult:response];
//    }
    [self.presenter onReGeocodeSearchDone:request response:response];
}


#pragma mark --POI查询回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    
    [self.presenter onPOISearchDone:request response:response];
}

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    [self.presenter onRouteSearchDone:request response:response];
}
 

//- (void)prepareSearchServiceWithMapView:(MAMapView *)mapView {
//
//    self.searchService = [[DGMapSearch alloc] initWithMapView:mapView];
//    self.searchService.searchDelegate = self.presenter.userInterface;
//
//}
//
//
//- (void)confirmCityWithLocation:(CLLocation *)location {
//    [self saveUserCurrentLocation:location];
//    [self.searchService searchReGeocodeWithCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
//
////    [self.searchService searchPoiWithCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
//
//
//}
//
//
//- (void)searchLocationDataWithLocation:(CLLocation *)location andType:(DGMapViewActionType)type {
//    self.dataManager.currentType = type;
//    [self.searchService searchAroundWithKeyWords:@"" InCity:[self.dataManager userCurrentCity] andCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
//
//}
//
//
//- (void)saveUserCurrentLocation:(CLLocation *)location {
//    self.dataManager.userLocation = location;
//}
//
//
//
//#pragma mark -- DGMapSearchDelegate
//
//- (void)coordinatePOISearchResult:(AMapPOISearchResponse *)data InRequest:(AMapPOISearchBaseRequest *)request {
//
//    if(self.dataManager.currentType ==DGMapViewActionType_UserLocation){
//        if(data && data.pois.count>0) {
//            AMapPOI * poi = [data.pois firstObject];
//            self.dataManager.userLocationPOI = poi;
//            if([self.presenter.delegate respondsToSelector:@selector(mapServiceHasConfirmedUserCity:)]){
//                [self.presenter.delegate mapServiceHasConfirmedUserCity:poi.city];
//            }
//
//            [self.presenter requestToChooseStartPoint];
//            [self.presenter updateStartPointWithData:poi];
//        }
//    }else{
//
//        if([self.presenter.delegate respondsToSelector:@selector(mapServiceLocationPOIResultList:)]){
//            [self.presenter.delegate mapServiceLocationPOIResultList:data.pois];
//        }
//        [self.presenter dragSearchPOIList:data.pois];
//        AMapPOI * poi = [data.pois firstObject];
//        [self.presenter updateStartPointWithData:poi];
//
//    }
//
//
//
//}
//
//
//- (void)coordinateGeocodeSearchResult:(AMapReGeocodeSearchResponse *)data InRequest:(AMapReGeocodeSearchRequest *)request {
//    [self.presenter requestToChooseStartPoint];
//    [self.presenter dragSearchedAOIResult:data.regeocode.aois anPOIs:data.regeocode.pois];
//}


- (AMapSearchAPI *)search {
    if(!_search){
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}


@end
