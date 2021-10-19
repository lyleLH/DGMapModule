//
//  DGMapViewResultData.h
//  DGMapModule
//
//  Created by Tom on 2021/10/19.
//

#import <Foundation/Foundation.h>
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DGMapViewResultData : NSObject
@property(nonatomic,strong)AMapReGeocodeSearchResponse * userCurrentLocationRegeoResponse;
@property(nonatomic,strong)AMapReGeocodeSearchResponse * choosedLocationRegeoResponse;
@end

NS_ASSUME_NONNULL_END
