//
//  DGMapSearch.h
//  DGMapModule
//
//  Created by Tom on 2021/9/24.
//

#import <Foundation/Foundation.h>
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>


NS_ASSUME_NONNULL_BEGIN



@protocol DGMapSearchDelegate <NSObject>

- (void)coordinatePOISearchResult:(AMapPOISearchResponse *)data InRequest:(AMapPOISearchBaseRequest *)request;

@end



@interface DGMapSearch : NSObject
///一个search对象，用于地理位置逆编码
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,weak) id <DGMapSearchDelegate> searchDelegate;

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiWithCenterCoordinate:(CLLocationCoordinate2D )coord  ;

- (void)searchAroundWithKeyWords:(NSString*)keywords  InCity:(NSString*)city andCoordinate:(CLLocationCoordinate2D)coordinate ;
@end

NS_ASSUME_NONNULL_END
