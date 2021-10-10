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


typedef enum : NSUInteger {
    DGMapServiceType_chooseStartPoint,
    DGMapServiceType_chooseEndPoint,
    DGMapServiceType_shouRoutePath,
    DGMapServiceType_searchAddressList,
} DGMapServiceType;

@interface DGMapViewManager : NSObject<DGMapModuleServiceInterface>

@property(nonatomic,assign)BOOL canDragToChoosePoint;

@property (nonatomic,weak) id <DGMapModuleServiceDelegate> delegate;
///地图对象
@property(nonatomic,strong,readonly)MAMapView *mapView;

@property(nonatomic,strong,readonly) DGMapSearch * mapSearch;

@property(nonatomic,assign)DGMapServiceType serviceType;


@end

NS_ASSUME_NONNULL_END
