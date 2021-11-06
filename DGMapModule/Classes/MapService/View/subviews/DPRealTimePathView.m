//
//  DPRealTimePathView.m
//  DGMapModule
//
//  Created by mttgcc on 11/2/21.
//

#import "DPRealTimePathView.h"
#import "PointAnnotation.h"
#import "DDCustomAnnotationView.h"
#import "UIImage+BundleImage.h"
#import "POIAnnotation.h"
#import "MAMapView+ZoomLevel.h"

@interface DPRealTimePathView  ()

@end

@implementation DPRealTimePathView

- (void)setMapView:(MAMapView *)mapView {
    _mapView = mapView;
    mapView.delegate = self;
    [mapView removeAnnotations:mapView.annotations];
    [mapView removeOverlays:mapView.overlays];
    
    _mapView.scrollEnabled = YES;
    [self addSubview:_mapView];
}

- (void)updateCarsLocation:(DGMapLocationModel*)model withFixPoint:(DGMapLocationModel*)point {
///下面两行代码 进入地图就显示定位小蓝点
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self showFixedLocation:point];
}


- (void)setMapViewType:(DGMapViewActionType)type {
    _chooseType = type;
}

- (void)layoutSubviews {
    [super layoutSubviews];
 
    [self.mapView setFrame:self.bounds];
}

#pragma mark  -- private

- (void)showFixedLocation:(DGMapLocationModel *)model{
    NSString * addres = @"您将在此处上车";
//    NSString * addres = [self shortAddressWithResponse:response];
    PointAnnotation * point  = [[PointAnnotation  alloc] initWithAddress:addres andLocation:model.location];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(model.location.latitude, model.location.longitude) animated:YES];

    [self.mapView addAnnotation:point];
    [self.mapView zoomToFitMapAnnotations];
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
        annotationView.image = [UIImage mt_imageWithName:_chooseType==DGMapViewActionType_PickEndLocation?@"icon_image_end":@"icon_image_start" inBundle:@"DGMapModule"];;
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
            image = [UIImage mt_imageWithName:_chooseType==DGMapViewActionType_PickEndLocation?@"icon_image_end":@"icon_image_start" inBundle:@"DGMapModule"];
            annotationView.calloutView.hidden = NO;

        }else{
            annotationView.calloutView.hidden = YES;
            [annotationView.imageView setFrame:CGRectMake(0, 0, 44, 44)];
        }


        annotationView.image = image;
        return annotationView;
    }

    return nil;
}


@end
