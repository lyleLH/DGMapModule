//
//  POIAnnotation.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
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

@interface POIAnnotation : NSObject <MAAnnotation>

- (id)initWithPOI:(AMapPOI *)poi;

- (id)initWithTitle:(NSString *)title andAddress:(NSString*)address;

@property (nonatomic, copy,readonly) NSString *tag;

@property (nonatomic, readonly, strong) AMapPOI *poi;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*!
 @brief 获取annotation标题
 @return 返回annotation的标题信息
 */
- (NSString *)title;

/*!
 @brief 获取annotation副标题
 @return 返回annotation的副标题信息
 */
- (NSString *)subtitle;

- (void)setTag:(NSString *)tag;

-(NSString *)tag;

@end
