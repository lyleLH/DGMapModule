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


#pragma mark - DGLocationChooseMapViewDelegate methods

 

#pragma mark - DGMapServiceModuleInterface methods


- (UIView *) papredMapViewWithType:(DGMapViewActionType )type {
    [self.userInterface setMapViewType:type];
    self.interactor.dataManager.intialType = type;
    if(type == DGMapViewActionType_ConfirmTwoPoint){
        [self searchRouterWithStartLocation:self.interactor.dataManager.startLocationData.location endLocation:self.interactor.dataManager.endLocationData.location];
    }
    return  self.userInterface;
}

// implement module interface here
- (void)userSelectAPOIPointToShowInMap:(NSDictionary*)poi {
    [self.userInterface showAnPoiPoint:[AMapPOI mj_objectWithKeyValues:poi]];
}


- (void)searchRouterWithStartLocation:(CLLocationCoordinate2D)start endLocation:(CLLocationCoordinate2D)end {
    [self.interactor routeSearchWithStart:start end:end];
}

- (void)confirmedUserLocationCoordinate:(CLLocationCoordinate2D)location withType:(DGMapViewActionType)type {
    self.interactor.dataManager.currentType = type;
    if (type== DGMapViewActionType_UserLocation  ) {
        self.interactor.dataManager.userLocationData = [[DGMapLocationModel alloc] initWithLocation:location];
        [self.interactor searchReGeocodeWithCoordinate:location isUserLocation:YES];
        self.interactor.dataManager.isGettingUserLocationSearchResult = YES;
    }else if(type== DGMapViewActionType_PickStartLocation){
        self.interactor.dataManager.startLocationData = [[DGMapLocationModel alloc] initWithLocation:location];
        [self.interactor searchReGeocodeWithCoordinate:location isUserLocation:NO];
    }else if(type== DGMapViewActionType_PickEndLocation){
        self.interactor.dataManager.endLocationData = [[DGMapLocationModel alloc] initWithLocation:location];
        [self.interactor searchReGeocodeWithCoordinate:location isUserLocation:NO];
    }
}

 


- (void)userSearchKeyWord:(NSString *)keyword inCity:(NSString *)city aroundCoordinate:(CLLocationCoordinate2D)coordinate  {
    [self.interactor searchAroundWithKeyWords:keyword InCity:city andCoordinate:coordinate];
}


#pragma mark -- AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
  
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if(self.interactor.dataManager.isGettingUserLocationSearchResult){
      
        [self.interactor.dataManager.userLocationData  fillWtihRegeoResponse:response];
        if([self.delegate respondsToSelector:@selector(currentUserLocationData:)]){
            [self.delegate currentUserLocationData:self.interactor.dataManager.userLocationData ];
        }
        [self.userInterface showReGeoSearchResult:self.interactor.dataManager.userLocationData];
        self.interactor.dataManager.isGettingUserLocationSearchResult = NO;
        self.interactor.dataManager.currentType = self.interactor.dataManager.intialType;
    }else{
        if(self.interactor.dataManager.currentType == DGMapViewActionType_PickStartLocation){
            [self.interactor.dataManager.startLocationData  fillWtihRegeoResponse:response];
            if([self.delegate respondsToSelector:@selector(currentChoosedLocationData:)]){
                [self.delegate currentChoosedLocationData:self.interactor.dataManager.startLocationData];
            }
            [self.userInterface showReGeoSearchResult:self.interactor.dataManager.startLocationData];
        }else if(self.interactor.dataManager.currentType == DGMapViewActionType_PickEndLocation){
            [self.interactor.dataManager.endLocationData  fillWtihRegeoResponse:response];
            if([self.delegate respondsToSelector:@selector(currentChoosedLocationData:)]){
                [self.delegate currentChoosedLocationData:self.interactor.dataManager.endLocationData];
            }
            [self.userInterface showReGeoSearchResult:self.interactor.dataManager.endLocationData];
        }
    }
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if([self.delegate respondsToSelector:@selector(userSearchKeyWordsResponse:)]){
        [self.delegate userSearchKeyWordsResponse:response];
    }

}

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    [self.userInterface showRouterSearchResult:response withStart:self.interactor.dataManager.startLocationData andEnd:self.interactor.dataManager.endLocationData];
}


@end
