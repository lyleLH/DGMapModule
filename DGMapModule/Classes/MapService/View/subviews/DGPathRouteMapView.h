//
//  DGPathRouteMapView.h
//  DGMapModule
//
//  Created by Tom on 2021/10/25.
//

#import <UIKit/UIKit.h>
//基础定位类
#import <AMapFoundationKit/AMapFoundationKit.h>
//高德地图基础类
//#import <MAMapKit/MAMapKit.h>
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>
//高德导航类
#import <AMapNaviKit/AMapNaviKit.h>
#import "DGMapServiceViewInterface.h"
NS_ASSUME_NONNULL_BEGIN
@protocol DGPathRouteMapViewProtocol
- (void)cancleCurrentRoutePath;
@end

@interface DGPathRouteMapView : UIView <DGMapServiceViewInterface>
@property(nonatomic,weak)MAMapView *mapView;
@property (nonatomic, strong) id<DGPathRouteMapViewProtocol> eventHandler;

@end

NS_ASSUME_NONNULL_END
