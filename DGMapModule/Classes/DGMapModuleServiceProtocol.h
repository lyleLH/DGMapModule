//
//  DGMapModuleServiceProtocol.h
//  DGMapModule
//
//  Created by Tom on 2021/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DGMapModuleServiceInterface<NSObject>

//根据起点和终点规划路线
- (void)planAnRoutePathWithPointStart:(NSDictionary*)start end:(NSDictionary*)end;

//显示地图和当前定位
- (void)showMapAndLoactionInView:(UIViewController * )vc;

//根据城市和关键字 搜索POI
- (void)getCurrentAroundPOIWithCity:(NSString *)city andKeyWord:(NSString *)keyword;

//展示/更新选择的起点
- (void)updateChoosedStartLocation:(id)data;
//展示/更新选择的终点
- (void)updateChoosedEndLocation:(id)data;

//清除地图上的路径
- (void)clearAllPath;

@end


@protocol DGMapModuleServiceDelegate <NSObject>

- (void)updateUserLocation:(NSDictionary *)data;

- (void)userDidSelectedAddressCalloutView:(id)data;

 
- (void)userChoosePlaceAddress:(NSString *)address details:(NSDictionary *)details withType:(NSInteger)type;

- (void)userSearchCityAndKeyWordResult:(NSArray *)result ;

- (void)userChoosenAddressClicked:(id)data;
 
@end


NS_ASSUME_NONNULL_END
