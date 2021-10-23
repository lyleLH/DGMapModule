//
//  DGMapServiceInteractorProtocol.h
//  DGMapModule
//
//  Created by Tom on 2021/10/23.
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

@protocol DGMapServiceInteractorDelegate <AMapSearchDelegate>

@end

NS_ASSUME_NONNULL_END
