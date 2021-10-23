//
//  DGMapServiceDataManager.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>
 #import <AMapNaviKit/AMapNaviKit.h>
 
NS_ASSUME_NONNULL_BEGIN

/**
 Data manager for the MapService module.
 */
@interface DGMapServiceDataManager : NSObject

@property(nonatomic,assign) BOOL isGettingUserLocationSearchResult;
@property (nonatomic,assign)CLLocationCoordinate2D userLocationCoordinate;
@property (nonatomic,assign)CLLocationCoordinate2D choosedLocationCoordinate;

 

@property (nonatomic,strong)AMapPOI * userLocationPOI;
@property (nonatomic,strong)AMapPOI * startLocationPOI;
@property (nonatomic,strong)AMapPOI * endLocationPOI;

- (NSString *)userCurrentCity;

- (void)saveUserLocation:(CLLocationCoordinate2D)coordinate;
- (void)updateChooseLocation:(CLLocationCoordinate2D)coordinate;

- (void)saveUserLocationSearchResult:(AMapReGeocodeSearchResponse *)response ;
- (void)saveChoosedLocationSearchResult:(AMapReGeocodeSearchResponse *)response ;

@end

NS_ASSUME_NONNULL_END
