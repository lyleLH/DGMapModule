//
//  DDCustomAnnotationView.h
//  DingDing
//
//  Created by Dry on 2017/6/13.
//  Copyright © 2017年 ddtech. All rights reserved.

//  大头针视图


//基础定位类
#import <AMapFoundationKit/AMapFoundationKit.h>
//高德地图基础类
//#import <MAMapKit/MAMapKit.h>
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>
//高德导航类
#import <AMapNaviKit/AMapNaviKit.h>

#import "DDCustomCalloutView.h"

@interface DDCustomAnnotationView : MAAnnotationView
@property (nonatomic,strong)UILabel * addressLabel;
@property (nonatomic, strong) DDCustomCalloutView *calloutView;

@end
