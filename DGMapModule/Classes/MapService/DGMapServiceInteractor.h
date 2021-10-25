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

#import "DGMapServiceInteractorProtocol.h"

@class DGMapServicePresenter;

@class MAMapView;

/**
 Business logic for the MapService module.
 */
@interface DGMapServiceInteractor : NSObject

@property (nonatomic, weak) DGMapServicePresenter <DGMapServiceInteractorDelegate>*presenter;
@property (nonatomic, strong) DGMapServiceDataManager *dataManager;
@property(nonatomic,strong)AMapSearchAPI *search;

- (void)searchAroundWithKeyWords:(NSString*)keywords  InCity:(NSString*)city andCoordinate:(CLLocationCoordinate2D)coordinate ;

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate isUserLocation:(BOOL)isUseLocation;

- (void)routeSearchWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end ;
 
@end
