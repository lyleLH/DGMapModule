//
//  DGMapView.m
//  DGMapModule
//
//  Created by Tom on 2021/10/10.
//

#import "DGMapView.h"

#import "DGLocationChooseMapView.h"
#import "DGPathRouteMapView.h"





@interface DGMapView () <MAMapViewDelegate>

@property (nonatomic, assign)  DGMapViewActionType mapViewActionType;
@property (nonatomic,strong)DGPathRouteMapView * pathRouteView;
@property (nonatomic,strong)DGLocationChooseMapView * mapChooseView;


@end

@implementation DGMapView

- (void)showReGeoSearchResult:(AMapReGeocodeSearchResponse *)response {
    [self.mapChooseView showReGeoSearchResult:response];
}

- (void)showRouterSearchResult:(AMapRouteSearchResponse *)response withStart:(DGMapLocationModel *)start andEnd:(DGMapLocationModel*)end {
    [self.pathRouteView showRouterSearchResult:response withStart:start andEnd:end];

}


- (void)setMapViewType:(DGMapViewActionType) type {
    _mapViewActionType = type;
    if(type == DGMapViewActionType_UserLocation)
    {
        [self.pathRouteView removeFromSuperview];
        [self addSubview:self.mapChooseView];
    }else if(type ==DGMapViewActionType_ConfirmTwoPoint){
        [self.mapChooseView removeFromSuperview];
        [self addSubview:self.pathRouteView];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if(_mapViewActionType  == DGMapViewActionType_ConfirmTwoPoint){
        [self.pathRouteView setFrame:self.bounds];
    } else if(_mapViewActionType  == DGMapViewActionType_UserLocation){
        [self.mapChooseView setFrame:self.bounds];
    }
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



@end
