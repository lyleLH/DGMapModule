//
//  DGMapServicePresenter.m
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import "DGMapServicePresenter.h"

@implementation DGMapServicePresenter

#pragma mark - DGMapServiceModuleInterface methods

 

// implement module interface here

//得到用户当前位置
- (void)confirmedUserLocationCoordinate:(CLLocationCoordinate2D)coordinate  {
    [self.interactor searchReGeocodeWithCoordinate:coordinate isUserLocation:YES];
}

//拖动到新的位置
- (void)userDargToNewLocationCoordinate:(CLLocationCoordinate2D)coordinate  {
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
    NSLog(@"💥💥💥💥 %@",error);
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


//- (void)requestToChooseStartPoint {
//
//    [self.userInterface updateMapViewActionType:DGMapViewActionType_PickStartLocation];
//}
//
//- (void)requestToChooseEndPoint {
//
//    [self.userInterface updateMapViewActionType:DGMapViewActionType_PickEndLocation];
//}
//
////滑动地图到新的位置
//- (void)mapviewScrollToANewLoaction:(CLLocation *)location withType:(DGMapViewActionType)type {
//    [self.interactor searchLocationDataWithLocation:location andType:type];
//}
//
//
////在POI点显示起点大头针
//- (void)updateStartPointWithData:(AMapPOI *)poi  {
//    [self.userInterface addAnAnnotaionViewWithPOIData:poi];
//}
//
////拖动后搜索的POI结果 显示
//- (void)dragSearchPOIList:(NSArray <AMapPOI *> *)pois   {
//    [self.userInterface showAroundPoiData:pois];
//}
//
////拖动后搜索的AOI结果 显示
//- (void)dragSearchedAOIResult:(NSArray <AMapAOI *> *)aoi anPOIs:(NSArray<AMapPOI *> *)poi   {
//    [self.userInterface showPointAOIData:aoi];
//}

@end
