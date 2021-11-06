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

    if(type == DGMapViewActionType_ConfirmTwoPoint){
        [self searchRouterWithStartLocation:self.interactor.dataManager.startLocationData.location endLocation:self.interactor.dataManager.endLocationData.location];
    }else if(type == DGMapViewActionType_WaittingCar){

    }
    [self.userInterface setMapViewType:type];
    self.interactor.dataManager.intialType = type;
    return  self.userInterface;
}


- (void)userSearchKeyWord:(NSString *)keyword inCity:(NSString *)city aroundCoordinate:(CLLocationCoordinate2D)coordinate  {
   [self.interactor searchAroundWithKeyWords:keyword InCity:city andCoordinate:coordinate];
}


- (void)updateCarLocationInMap:(DGMapLocationModel*)carData {
    [self.userInterface updateCarsLocation:carData withFixPoint:self.interactor.dataManager.endLocationData];
}




#pragma mark -  DGLocationChooseMapViewDelegate
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




#pragma -- private

- (void)userSelectAPOIPointToShowInMap:(NSDictionary*)poi {
    [self.userInterface showAnPoiPoint:[AMapPOI mj_objectWithKeyValues:poi]];
}


- (void)searchRouterWithStartLocation:(CLLocationCoordinate2D)start endLocation:(CLLocationCoordinate2D)end {
    [self.interactor routeSearchWithStart:start end:end];
}



@end
