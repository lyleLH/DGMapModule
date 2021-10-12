//
//  MAMapView+ZoomLevel.h
//  DGMapModule
//
//  Created by Tom on 2021/10/12.
//

#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAMapView (ZoomLevel)
- (NSUInteger)getZoomLevel;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (void)zoomToFitMapAnnotations;

- (void)zoomToFitMapAnnotationsWithFactor:(CGFloat)factor ;
@end

NS_ASSUME_NONNULL_END
