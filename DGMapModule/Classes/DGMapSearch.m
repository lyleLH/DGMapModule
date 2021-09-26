//
//  DGMapSearch.m
//  DGMapModule
//
//  Created by Tom on 2021/9/24.
//

#import "DGMapSearch.h"

@interface DGMapSearch ()<AMapSearchDelegate>

@end

@implementation DGMapSearch

- (AMapSearchAPI *)search {
    if(!_search){
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

 
- (void)searchPoiWithCenterCoordinate:(CLLocationCoordinate2D )coord  {
    AMapPOIAroundSearchRequest*request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coord.latitude  longitude:coord.longitude];
    request.radius   = 1000;
    //    request.types = self.currentType;
    request.sortrule = 0;
    //    request.page     = self.searchPage;
    [self.search AMapPOIAroundSearch:request];
}


#pragma mark -- AMapSearchDelegate


#pragma mark --POI查询回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    [self.searchDelegate coordinatePOISearchResult:response InRequest:request];
}


#pragma mark --地址编码回调
-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    AMapGeoPoint *point = response.geocodes[0].location;
    NSLog(@"----%lf====%lf",point.latitude,point.latitude);
}

#pragma mark --地址编码回调逆地理编码

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
}



- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"💥💥💥💥 %@",error);
}




-(void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
}

- (void)searchAroundWithKeyWords:(NSString*)keywords  InCity:(NSString*)city andCoordinate:(CLLocationCoordinate2D)coordinate {
    AMapPOIAroundSearchRequest  *request=[[AMapPOIAroundSearchRequest alloc] init];
    request.radius = 10000;
    request.city = city;
    request.location=[AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.keywords = keywords;
    [self.search AMapPOIAroundSearch:request];
}





@end
