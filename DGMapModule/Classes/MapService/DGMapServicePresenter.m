//
//  DGMapServicePresenter.m
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import "DGMapServicePresenter.h"
#import <MJExtension/MJExtension.h>
@implementation DGMapServicePresenter

#pragma mark - DGMapServiceModuleInterface methods

- (void)setMapViewCanBeDrag:(BOOL)canBeDrag {
    [self.userInterface setMapViewCanBeDrag:canBeDrag];
}

// implement module interface here
- (void)userSelectAPOIPointToShowInMap:(NSDictionary*)poi {
    [self.userInterface showAnPoiPoint:[AMapPOI mj_objectWithKeyValues:poi]];
}


- (void)searchRouterWithStartLocation:(CLLocationCoordinate2D)start endLocation:(CLLocationCoordinate2D)end {
    [self.interactor routeSearchWithStart:start end:end];
}

//得到用户当前位置
- (void)confirmedUserLocationCoordinate:(CLLocationCoordinate2D)coordinate  {
    if([self.delegate respondsToSelector:@selector(userCurrentLoction:)]){
        [self.delegate userCurrentLoction:coordinate];
    }
    [self.interactor searchReGeocodeWithCoordinate:coordinate isUserLocation:YES];
}

//拖动到新的位置
- (void)userDargToNewLocationCoordinate:(CLLocationCoordinate2D)coordinate  {
    if([self.delegate respondsToSelector:@selector(userChoosedLoction:)]){
        [self.delegate userChoosedLoction:coordinate];
    }
    [self.interactor searchReGeocodeWithCoordinate:coordinate isUserLocation:NO];
    
}


- (void)userSearchKeyWord:(NSString *)keyword inCity:(NSString *)city aroundCoordinate:(CLLocationCoordinate2D)coordinate  {
    [self.interactor searchAroundWithKeyWords:keyword InCity:city andCoordinate:coordinate];
}


- (void)updaMapViewWithSearchResult:(AMapReGeocodeSearchResponse *)response {
    [self.userInterface showReGeoSearchResult:response];
}


#pragma mark -- AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
  
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if(self.interactor.dataManager.isGettingUserLocationSearchResult){
        if([self.delegate respondsToSelector:@selector(userCurrentLoctionData:)]){
            [self.delegate userCurrentLoctionData:response];
        }
    }else{
        if([self.delegate respondsToSelector:@selector(userChoosedLoctionData:)]){
            [self.delegate userChoosedLoctionData:response];
        }
    }
    
    [self.userInterface showReGeoSearchResult:response];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if([self.delegate respondsToSelector:@selector(userSearchKeyWordsResponse:)]){
        [self.delegate userSearchKeyWordsResponse:response];
    }

}

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    [self.userInterface showRouterSearchResult:response];
}


@end
