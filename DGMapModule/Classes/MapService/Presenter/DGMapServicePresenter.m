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

- (void)mapviewGetUserCurrentLoaction:(CLLocation *)location {
    [self.interactor confirmCityWithLocation:location];
}

- (void)requestToChooseStartPoint {
    
    [self.userInterface updateMapViewActionType:DGMapViewActionType_PickStartLocation];
}

- (void)requestToChooseEndPoint {
    
    [self.userInterface updateMapViewActionType:DGMapViewActionType_PickEndLocation];
}


- (void)mapviewScrollToANewLoaction:(CLLocation *)location withType:(DGMapViewActionType)type {
    [self.interactor searchLocationDataWithLocation:location andType:type];
}

- (void)updateStartPointWithData:(AMapPOI *)poi  {
    [self.userInterface addAnAnnotaionViewWithPOIData:poi];
}

@end
