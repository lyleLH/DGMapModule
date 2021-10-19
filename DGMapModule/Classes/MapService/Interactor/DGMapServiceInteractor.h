//
//  DGMapServiceInteractor.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <Foundation/Foundation.h>

#import "DGMapServicePresenter.h"
#import "DGMapServiceDataManager.h"

@class DGMapServicePresenter;

@class MAMapView;

/**
 Business logic for the MapService module.
 */
@interface DGMapServiceInteractor : NSObject

@property (nonatomic, weak) DGMapServicePresenter *presenter;
@property (nonatomic, strong) DGMapServiceDataManager *dataManager;

- (void)prepareSearchServiceWithMapView:(MAMapView *)mapView ;


- (void)confirmCityWithLocation:(CLLocation *)location;

- (void)searchLocationDataWithLocation:(CLLocation *)location andType:(DGMapViewActionType)type ;

- (void)searchLocationDataReGeo:(CLLocation *)location andType:(DGMapViewActionType)type ;

@end
