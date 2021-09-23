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

NS_ASSUME_NONNULL_BEGIN
@protocol DGMapViewManagerDelegate <NSObject>

- (void)userChoosePlaceAddress:(NSString *)address details:(NSDictionary *)details;

@end



@interface DGMapViewManager : NSObject
@property (nonatomic,weak) id <DGMapViewManagerDelegate> delegate;
///地图对象
@property(nonatomic,strong)MAMapView *mapView;
///一个search对象，用于地理位置逆编码
@property(nonatomic,strong)AMapSearchAPI *search;

//当前定位
//@property(nonatomic,strong,readonly) CLLocation *currentLocation;

- (void)showMapWithFrame:(CGRect)frame inSuperView:(UIView *)superView ;
//TODO: 在搜索位置时开始顶部提示，搜索到结果之后 将位置信息返回给实例进行保存，取消提示，此时的calloutview 可以开始显示实例所保存的自定义的位置信息

@end

NS_ASSUME_NONNULL_END
