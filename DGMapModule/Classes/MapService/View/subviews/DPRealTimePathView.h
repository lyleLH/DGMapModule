//
//  DPRealTimePathView.h
//  DGMapModule
//
//  Created by mttgcc on 11/2/21.
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

@interface DPRealTimePathView : UIView<DGMapServiceViewInterface>
@property (nonatomic, assign) DGMapViewActionType chooseType;
@property(nonatomic,weak)MAMapView *mapView;
@end

NS_ASSUME_NONNULL_END
