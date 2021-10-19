//
//  DGMapServicePresenter.m
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import "DGMapServicePresenter.h"

@implementation DGMapServicePresenter

#pragma mark - DGMapServiceModuleInterface methods

// implement module interface here

//得到用户当前位置
- (void)mapviewGetUserCurrentLoaction:(CLLocation *)location {
    [self.interactor confirmCityWithLocation:location];
}

//- (void)requestToChooseStartPoint {
//
//    [self.userInterface updateMapViewActionType:DGMapViewActionType_PickStartLocation];
//}
//
//- (void)requestToChooseEndPoint {
//
//    [self.userInterface updateMapViewActionType:DGMapViewActionType_PickEndLocation];
//}
//
////滑动地图到新的位置
//- (void)mapviewScrollToANewLoaction:(CLLocation *)location withType:(DGMapViewActionType)type {
//    [self.interactor searchLocationDataWithLocation:location andType:type];
//}
//
//
////在POI点显示起点大头针
//- (void)updateStartPointWithData:(AMapPOI *)poi  {
//    [self.userInterface addAnAnnotaionViewWithPOIData:poi];
//}
//
////拖动后搜索的POI结果 显示
//- (void)dragSearchPOIList:(NSArray <AMapPOI *> *)pois   {
//    [self.userInterface showAroundPoiData:pois];
//}
//
////拖动后搜索的AOI结果 显示
//- (void)dragSearchedAOIResult:(NSArray <AMapAOI *> *)aoi anPOIs:(NSArray<AMapPOI *> *)poi   {
//    [self.userInterface showPointAOIData:aoi];
//}

@end
