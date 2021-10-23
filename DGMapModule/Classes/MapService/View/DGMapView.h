//
//  DGMapView.h
//  DGMapModule
//
//  Created by Tom on 2021/10/10.
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

#import "DGMapViewServiceTypeDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface DGMapView : UIView <DGMapServiceViewInterface,AMapSearchDelegate>
@property (nonatomic, strong) id<DGMapServiceModuleInterface> eventHandler;

@property (nonatomic, assign,readonly)  DGMapViewActionType mapViewActionType;;

@end

NS_ASSUME_NONNULL_END
