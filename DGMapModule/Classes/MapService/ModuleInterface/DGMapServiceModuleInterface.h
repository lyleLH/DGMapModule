//
//  DGMapServiceModuleInterface.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <Foundation/Foundation.h>


@class CLLocation;
/**
 Module interface for the MapService module.
 */
@protocol DGMapServiceModuleInterface <NSObject>

@optional
///地图视图事件
///得到用户的当前定位信息
- (void)mapviewGetUserCurrentLoaction:(CLLocation *)location;

- (void)mapviewGetUserCurrentLoactionPOIData:(NSDictionary *)poi;

- (void)requestToChooseStartPoint;

@end

 
/**
 Module delegate for the MapService module.
 */
@protocol DGMapServiceModuleDelegate <NSObject>

- (void)mapServiceHasConfirmedUserCity:(NSString *)city;
@end
