//
//  PointAnnotation.h
//  DGMapModule
//
//  Created by Tom on 2021/10/21.
//

//基础定位类
#import <AMapFoundationKit/AMapFoundationKit.h>
//高德地图基础类
//#import <MAMapKit/MAMapKit.h>
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>
//高德导航类
#import <AMapNaviKit/AMapNaviKit.h>

#import <AMapSearchKit/AMapCommonObj.h>


NS_ASSUME_NONNULL_BEGIN

@interface PointAnnotation : NSObject<MAAnnotation>
- (instancetype)initWithAddress:(NSString *)address andLocation:(CLLocationCoordinate2D)location;
@end

NS_ASSUME_NONNULL_END
