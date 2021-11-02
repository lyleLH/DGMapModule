//
//  DGMapView.m
//  DGMapModule
//
//  Created by Tom on 2021/10/10.
//

#import "DGMapView.h"

#import "DGLocationChooseMapView.h"
#import "DGPathRouteMapView.h"
#import "DPRealTimePathView.h"




@interface DGMapView () <MAMapViewDelegate>

@property (nonatomic, assign)  DGMapViewActionType mapViewActionType;

@property (nonatomic,strong)MAMapView *mapView;

@property (nonatomic,strong)DGPathRouteMapView * pathRouteView;
@property (nonatomic,strong)DGLocationChooseMapView * mapChooseView;
@property (nonatomic,strong)DPRealTimePathView * realTimeMapView;

@property (nonatomic,strong)UIView <DGMapServiceViewInterface>* mapContainerView;

@end

@implementation DGMapView

- (void)showReGeoSearchResult:(DGMapLocationModel *)response {
 
    [self.mapChooseView showReGeoSearchResult:response];
}

- (void)showRouterSearchResult:(AMapRouteSearchResponse *)response withStart:(DGMapLocationModel *)start andEnd:(DGMapLocationModel*)end {

    [self.pathRouteView showRouterSearchResult:response withStart:start andEnd:end];

}


- (void)setMapViewType:(DGMapViewActionType) type {
    _mapViewActionType = type;
    [self.mapContainerView removeFromSuperview];
    self.mapContainerView = nil;
   if(type == DGMapViewActionType_PickStartLocation){
       self.mapChooseView.mapView = self.mapView;
        self.mapContainerView = self.mapChooseView;
        
    }else if(type == DGMapViewActionType_PickEndLocation){
        self.mapChooseView.mapView = self.mapView;
        self.mapContainerView = self.mapChooseView;
        
    }else if(type ==DGMapViewActionType_ConfirmTwoPoint){
        [self.pathRouteView setMapView:self.mapView];
        self.mapView.delegate = self.pathRouteView;
        self.mapContainerView = self.pathRouteView;
  
     }else  if(type ==DGMapViewActionType_WaittingCar){
         
         self.realTimeMapView = [[DPRealTimePathView alloc] init];
         self.mapView.delegate  = self.realTimeMapView;
         
         self.realTimeMapView.mapView = self.mapView;
         self.mapContainerView = self.realTimeMapView;
         
     }
    
    [self.mapContainerView setMapViewType:type];
    [self addSubview:self.mapContainerView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.mapContainerView setFrame:self.bounds];
}


- (DGPathRouteMapView *)pathRouteView {
    if(!_pathRouteView){
        _pathRouteView = [[DGPathRouteMapView alloc] init];
    }
    return _pathRouteView;
}



- (DGLocationChooseMapView *)mapChooseView {
    if(!_mapChooseView){
        _mapChooseView = [[DGLocationChooseMapView alloc] init];
        _mapChooseView.eventHandler = self.eventHandler;
    }
    return _mapChooseView;
}

- (MAMapView *)mapView {
    if(!_mapView){
        _mapView = [[MAMapView alloc] initWithFrame:CGRectZero];

//        _mapView.scrollEnabled = NO;
        _mapView.mapType = MAMapTypeBus;
        ///下面两行代码 进入地图就显示定位小蓝点
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        //设置地图缩放比例，即显示区域
        [_mapView setZoomLevel:17 animated:YES];
        //设置定位精度
        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        //设置定位距离
        _mapView.distanceFilter = 5.0f;
        
    }
    return _mapView;
}


@end
