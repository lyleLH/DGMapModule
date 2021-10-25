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
#import "DGMapLocationModel.h"
NS_ASSUME_NONNULL_BEGIN

/**
 Data manager for the MapService module.
 */
@interface DGMapServiceDataManager : NSObject

@property(nonatomic,assign) BOOL isGettingUserLocationSearchResult;
@property (nonatomic,strong)DGMapLocationModel * userLocationData;

@property (nonatomic,strong)DGMapLocationModel * choosedLocationData;

@end

NS_ASSUME_NONNULL_END
