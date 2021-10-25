//
//  DGPathRouteMapView.m
//  DGMapModule
//
//  Created by Tom on 2021/10/25.
//

#import "DGPathRouteMapView.h"

#import "UIImage+BundleImage.h"


#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "DGMapLocationModel.h"


#import "POIAnnotation.h"
#import "DDCustomAnnotationView.h"
#import <MJExtension/MJExtension.h>
#import "PointAnnotation.h"



static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;



@interface DGPathRouteMapView ()

@property(nonatomic,strong)MAMapView *mapView;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;
@property (nonatomic, strong) AMapRoute *route;
/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;


@end

@implementation DGPathRouteMapView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.mapView];
    [self.mapView setFrame:self.bounds];
}

- (void)showRouterSearchResult:(AMapRouteSearchResponse *)response withStart:(DGMapLocationModel *)start andEnd:(DGMapLocationModel*)end {
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    PointAnnotation * point  = [[PointAnnotation  alloc] initWithAddress:start.poi.name.length>0?start.poi.name:@"当前位置" andLocation:start.location];
   
    [self.mapView addAnnotation:point];

    PointAnnotation * point2  = [[PointAnnotation  alloc] initWithAddress:end.poi.name.length>0?end.poi.name:@"当前位置" andLocation:end.location];
   
    [self.mapView addAnnotation:point2];
    
    
    self.route = response.route;
    self.currentCourse = 0;
    if (response.count > 0){
        [self presentCurrentCourseWith:CLLocationCoordinate2DMake(response.route.origin.latitude, response.route.origin.longitude)
                                andEnd:CLLocationCoordinate2DMake(response.route.destination.latitude, response.route.destination.longitude)
        ];
    }
}

/* 展示当前路线方案. */
- (void)presentCurrentCourseWith:(CLLocationCoordinate2D)start andEnd:(CLLocationCoordinate2D)end
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse]
                                      withNaviType:type
                                       showTraffic:YES
                                        startPoint:
                      [AMapGeoPoint locationWithLatitude:start.latitude
                                               longitude:start.longitude]
                                          endPoint:
                      [AMapGeoPoint locationWithLatitude:end.latitude
                                               longitude:end.longitude]
    ];
    
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDashType = kMALineDashTypeSquare;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 10;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        
        return polylineRenderer;
    }
    
    return nil;
}



- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    /*这里根据不同类型的大头针，生成不同的大头针视图
     为了方便起见我们继承MAPointAnnotation创建了自己的DDAnnotation，用来扩展更多属性，给大头针视图提供更多数据等
     */
    
    if([annotation isKindOfClass:[PointAnnotation class]]){
        static NSString *reusedID = @"DDPointAnnotation_reusedID";
        DDCustomAnnotationView *annotationView = (DDCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reusedID];
        
        if (!annotationView) {
            annotationView = [[DDCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusedID];
            annotationView.canShowCallout = NO;//设置此属性为NO，防止点击的时候高德自带的气泡弹出
        }
        
        PointAnnotation *point = (PointAnnotation *)annotation;
        annotationView.calloutView.textLabel.text = point.title;
        annotationView.calloutView.hidden = NO;
        annotationView.image = [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];;
        return annotationView;
    }
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *reusedID = @"DDPointAnnotation_reusedID";
        DDCustomAnnotationView *annotationView = (DDCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reusedID];
        
        if (!annotationView) {
            annotationView = [[DDCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusedID];
            annotationView.canShowCallout = NO;//设置此属性为NO，防止点击的时候高德自带的气泡弹出
        }
        
        //给气泡赋值
        POIAnnotation *ddAnnotation = (POIAnnotation *)annotation;
//        NSLog(@"********* %@ %@",ddAnnotation.title,ddAnnotation.number);
        annotationView.calloutView.textLabel.text = ddAnnotation.poi.name;
//        annotationView.calloutView.hidden = YES;
        UIImage * image = [UIImage mt_imageWithName:@"map_local_oil1" inBundle:@"DGMapModule"];
        
        if([[ddAnnotation tag] isEqualToString:@"起点"]){
            image = [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];
            annotationView.calloutView.hidden = NO;
         
        }else{
            annotationView.calloutView.hidden = YES;
        }
        
        
        annotationView.image = image;
        return annotationView;
    }
    
    return nil;
}




- (MAMapView *)mapView {
    if(!_mapView){
        _mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
        _mapView.scrollEnabled = YES;
        _mapView.mapType = MAMapTypeBus;
        _mapView.showsUserLocation = NO;
 
        //设置地图缩放比例，即显示区域
        [_mapView setZoomLevel:17 animated:YES];
        
        _mapView.delegate = self;
        //设置定位精度
        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        //设置定位距离
        _mapView.distanceFilter = 5.0f;
        
    }
    return _mapView;
}


@end
