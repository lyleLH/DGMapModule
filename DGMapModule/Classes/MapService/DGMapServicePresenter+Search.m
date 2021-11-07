//
//  DGMapServicePresenter+Search.m
//  DGMapModule
//
//  Created by mttgcc on 11/4/21.
//

#import "DGMapServicePresenter+Search.h"

@implementation DGMapServicePresenter (Search)
#pragma mark - AMapSearchDelegate

 
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
    if([self.delegate respondsToSelector:@selector(userSearchKeyWordsResponse:withType:)]){
        [self.delegate userSearchKeyWordsResponse:response withType:self.interactor.dataManager.currentType];
    }

}

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    [self.userInterface showRouterSearchResult:response withStart:self.interactor.dataManager.startLocationData andEnd:self.interactor.dataManager.endLocationData];
}
@end
