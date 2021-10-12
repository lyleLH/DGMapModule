//
//  DGMapServiceInteractor.m
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import "DGMapServiceInteractor.h"
#import "DGMapSearch.h"


@interface DGMapServiceInteractor () <DGMapSearchDelegate>

@property (nonatomic,strong)DGMapSearch * searchService;

@end

@implementation DGMapServiceInteractor

- (void)prepareSearchServiceWithMapView:(MAMapView *)mapView {
    
    self.searchService = [[DGMapSearch alloc] initWithMapView:mapView];
    self.searchService.searchDelegate = self;
    
}


- (void)confirmCityWithLocation:(CLLocation *)location {
    [self saveUserCurrentLocation:location];
    [self.searchService searchPoiWithCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
    
}


- (void)searchLocationDataWithLocation:(CLLocation *)location andType:(DGMapViewActionType)type {
    self.dataManager.currentType = type;
    [self.searchService searchAroundWithKeyWords:@"" InCity:[self.dataManager userCurrentCity] andCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
}


- (void)saveUserCurrentLocation:(CLLocation *)location {
    self.dataManager.userLocation = location;
}



#pragma mark -- DGMapSearchDelegate

- (void)coordinatePOISearchResult:(AMapPOISearchResponse *)data InRequest:(AMapPOISearchBaseRequest *)request {
    
    if(self.dataManager.currentType ==DGMapViewActionType_UserLocation){
        if(data && data.pois.count>0) {
            AMapPOI * poi = [data.pois firstObject];
            self.dataManager.userLocationPOI = poi;
            if([self.presenter.delegate respondsToSelector:@selector(mapServiceHasConfirmedUserCity:)]){
                [self.presenter.delegate mapServiceHasConfirmedUserCity:poi.city];
            }
            
            [self.presenter requestToChooseStartPoint];
            [self.presenter updateStartPointWithData:poi];
        }
    }else{
        
        if([self.presenter.delegate respondsToSelector:@selector(mapServiceLocationPOIResultList:)]){
            [self.presenter.delegate mapServiceLocationPOIResultList:data.pois];
        }
        
        AMapPOI * poi = [data.pois firstObject];
        [self.presenter updateStartPointWithData:poi];
        
    }
    
    
    
}






@end
