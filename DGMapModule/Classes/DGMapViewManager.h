//
//  DGMapViewManager.h
//  DGMapModule
//
//  Created by Tom on 2021/9/12.
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

#import "DGMapSearch.h"
#import "DGMapModuleServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DGMapViewManagerDelegate <NSObject>

- (void)userChoosePlaceAddress:(NSString *)address details:(NSDictionary *)details;

- (void)userSearchCityAndKeyWordResult:(NSArray *)result ;

- (void)userChoosenAddressClicked:(id)data;

@end



@interface DGMapViewManager : NSObject<DGMapModuleServiceInterface>
@property (nonatomic,weak) id <DGMapViewManagerDelegate> delegate;
///地图对象
@property(nonatomic,strong,readonly)MAMapView *mapView;

@property(nonatomic,strong,readonly) DGMapSearch * mapSearch;
 

@end

NS_ASSUME_NONNULL_END
