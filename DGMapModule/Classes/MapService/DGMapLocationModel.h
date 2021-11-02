//
//  DGMapLocationModel.h
//  DGMapModule
//
//  Created by Tom on 2021/10/24.
//

#import <Foundation/Foundation.h>
//基础定位类
#import <AMapFoundationKit/AMapFoundationKit.h>
//高德地图基础类
//#import <MAMapKit/MAMapKit.h>
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>
//高德导航类
#import <AMapNaviKit/AMapNaviKit.h>

typedef NS_ENUM(NSUInteger, DGMapLocationType) {
    DGMapLocationType_locationPoint,
    DGMapLocationType_poiPoint,
    DGMapLocationType_poiAroundPoint,
};


NS_ASSUME_NONNULL_BEGIN

@interface DGMapLocationModel : NSObject

@property(nonatomic,assign)CLLocationCoordinate2D location;
@property(nonatomic,strong)AMapPOI *poi;
@property(nonatomic,strong)NSArray <AMapPOI *>* aroundPois;
@property (nonatomic, strong) AMapReGeocode *regeocode; 

- (instancetype)initWithLocation:(CLLocationCoordinate2D )location;

- (void)fillWtihRegeoResponse:(AMapReGeocodeSearchResponse *)response;

@end

NS_ASSUME_NONNULL_END
