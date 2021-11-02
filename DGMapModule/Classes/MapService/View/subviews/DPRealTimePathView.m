//
//  DPRealTimePathView.m
//  DGMapModule
//
//  Created by mttgcc on 11/2/21.
//

#import "DPRealTimePathView.h"

@implementation DPRealTimePathView

- (void)setMapView:(MAMapView *)mapView {
    _mapView = mapView;
    [mapView removeAnnotations:mapView.annotations];
    [mapView removeOverlays:mapView.overlays];
    
    _mapView.scrollEnabled = YES;
    [self addSubview:_mapView];
}


- (void)setMapViewType:(DGMapViewActionType)type {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
 
    [self.mapView setFrame:self.bounds];
}

@end
