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

#import "DGMapModuleServiceProtocol.h"
#import <AMapNaviKit/AMapNaviKit.h>
NS_ASSUME_NONNULL_BEGIN

/**
 Data manager for the MapService module.
 */
@interface DGMapServiceDataManager : NSObject

@property (nonatomic,strong)CLLocation * userLocation;

@property (nonatomic,strong)AMapAOI * userLocationPOI;

@end

NS_ASSUME_NONNULL_END
