//
//  DGLocationChooseMapView.h
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

#import "DGMapServiceModuleInterface.h"

#import "DGMapServiceViewInterface.h"

#import "DGMapLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DGLocationChooseMapViewDelegate <NSObject>



- (void)confirmedUserLocationCoordinate :(CLLocationCoordinate2D)location withType:(DGMapViewActionType)type;



@end


@interface DGLocationChooseMapView : UIView <DGMapServiceViewInterface>
///地图对象
@property(nonatomic,weak)MAMapView *mapView;
@property (nonatomic, assign) DGMapViewActionType chooseType;
@property (nonatomic, strong) id<DGMapServiceModuleInterface,DGLocationChooseMapViewDelegate> eventHandler;



@end

NS_ASSUME_NONNULL_END
