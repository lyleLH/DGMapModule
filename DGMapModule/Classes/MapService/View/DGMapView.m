//
//  DGMapView.m
//  DGMapModule
//
//  Created by Tom on 2021/10/10.
//

#import "DGMapView.h"
#import "UIImage+BundleImage.h"
#import "CustomAnnotationView.h"
#import "POIAnnotation.h"
#import "MAMapView+ZoomLevel.h"

@interface DGMapView () <MAMapViewDelegate>

@property (nonatomic, assign)  DGMapViewActionType mapViewActionType;;

///地图对象
@property(nonatomic,strong)MAMapView *mapView;

@end

@interface DGMapView ()

@property (nonatomic, strong) UIImageView          *centerAnnotationView;

@property (strong, nonatomic) POIAnnotation *startAnnotation;
@property (strong, nonatomic) POIAnnotation *destinationAnnotation;
@property (nonatomic, strong) CustomAnnotationView * startAnnotationView ;
@property (nonatomic, strong) CustomAnnotationView * destinationAnnotationView ;

@end

@implementation DGMapView


#pragma mark -- DGMapServiceViewInterface

- (void)addAnAnnotaionViewWithPOIData:(AMapPOI *)poi {
 
    if(_mapViewActionType == DGMapViewActionType_PickStartLocation){
        if(poi ==nil){
            NSLog(@"请重新选择起点");
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude)];
            return;
            
        }
        
        
        [self.mapView removeAnnotation:self.startAnnotation];
        POIAnnotation *annotation = [[POIAnnotation alloc] initWithPOI:poi];
        self.startAnnotation = annotation;
        [annotation setTag:@"起点"];

        [self.mapView addAnnotation:self.startAnnotation];
        
        [self.mapView selectAnnotation:self.startAnnotation animated:YES];
        
    }else if(_mapViewActionType == DGMapViewActionType_PickEndLocation) {
        if(poi ==nil){
            NSLog(@"请重新选择终点");
            
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.startAnnotation.coordinate.latitude, self.startAnnotation.coordinate.longitude)];
            return;
        }
        
        [self.mapView removeAnnotation:self.destinationAnnotation ];
        POIAnnotation *annotation = [[POIAnnotation alloc] initWithPOI:poi];
        self.destinationAnnotation = annotation;

        [annotation setTag:@"终点"];
        [self.mapView addAnnotation:self.destinationAnnotation ];
        
        [self.mapView selectAnnotation:self.startAnnotation  animated:YES];
        [self.mapView selectAnnotation:self.destinationAnnotation  animated:YES];
        _mapViewActionType = DGMapViewActionType_ConfirmTwoPoint;
        [self caculateRegion];
    }
    [self centerAnnotationAnimimate];
    [self.centerAnnotationView removeFromSuperview];
    
    
}

- (void)caculateRegion {
    [self.mapView zoomToFitMapAnnotationsWithFactor:1.8];
}




- (void)setCenterWithLocation:( CLLocation *)loaction {
    self.mapView.centerCoordinate = loaction.coordinate;
    
}

- (void)updateMapViewActionType:(DGMapViewActionType)mapViewActionType {
    _mapViewActionType = mapViewActionType;
    self.mapView.scrollEnabled = YES;
}




- (instancetype)init {
    if(self ==[super init]){
        [self addSubview:self.mapView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.mapView setFrame:self.bounds];
}


#pragma mark 定位更新回调

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if(!updatingLocation)
        return ;
    
    if (userLocation.location.horizontalAccuracy < 0) {
        return ;
    }
    if(updatingLocation) {
        if (self.mapView.userTrackingMode == MAUserTrackingModeFollow) {
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
            self.mapView.userTrackingMode = MAUserTrackingModeNone;
            
            [self.eventHandler mapviewGetUserCurrentLoaction:[userLocation.location copy]];
        }
    }
    
}


#pragma mark - MAMapViewDelegate

-(void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    
    if(_mapViewActionType ==DGMapViewActionType_PickStartLocation){
        [self.mapView addSubview:self.centerAnnotationView];
        self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];
    }else if(_mapViewActionType ==DGMapViewActionType_PickEndLocation){
        [self.mapView addSubview:self.centerAnnotationView];
        self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_end" inBundle:@"DGMapModule"];
    }
    
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    if(_mapViewActionType != DGMapViewActionType_UserLocation){
        if (self.mapView.userTrackingMode == MAUserTrackingModeNone) {
            CLLocation * newLocation =  [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
            if(_mapViewActionType != DGMapViewActionType_ConfirmTwoPoint){
                [self.eventHandler mapviewScrollToANewLoaction:newLocation withType:_mapViewActionType];
            }

        }
    }
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }else if ([annotation isKindOfClass:[POIAnnotation class]]) {
        static NSString *reuseIndetifier = @"kCustomAnnotationView";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
            annotationView.buttonAction = ^{
//                if([self.delegate respondsToSelector:@selector(userChoosenAddressClicked:)]){
//                    [self.delegate userChoosenAddressClicked:@""];
//                }
            };
            
        }
        annotationView.canShowCallout = NO;
        POIAnnotation *poiAnno = (POIAnnotation *)annotation;
        
        [annotationView updateContent:poiAnno.poi.name];
        if([[poiAnno tag] isEqualToString:@"起点"]){
            annotationView.image =  [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];
        }else if([[poiAnno tag] isEqualToString:@"终点"]){
            annotationView.image =  [UIImage mt_imageWithName:@"icon_image_end" inBundle:@"DGMapModule"];
        }
 
        annotationView.selected = YES;
        // 设置为NO，用以调用自定义的calloutView
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);

 
        return annotationView;
    }
    
    
    return nil;
}

/* 移动窗口弹一下的动画 */
- (void)centerAnnotationAnimimate {
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        CGPoint center = self.centerAnnotationView.center;
        center.y -= 20;
        [self.centerAnnotationView setCenter:center];
        
    }
     
                     completion:nil];
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        CGPoint center = self.centerAnnotationView.center;
        center.y += 20;
        [self.centerAnnotationView setCenter:center];
        
    }
                     completion:nil];
}



- (MAMapView *)mapView {
    if(!_mapView){
        _mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
        _mapViewActionType = DGMapViewActionType_UserLocation;
        _mapView.scrollEnabled = NO;
        ///下面两行代码 进入地图就显示定位小蓝点
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        //设置地图缩放比例，即显示区域
        [_mapView setZoomLevel:17 animated:YES];
        
        _mapView.delegate = self;
        //设置定位精度
        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        //设置定位距离
        _mapView.distanceFilter = 5.0f;
        
        MAUserLocationRepresentation *represent = [[MAUserLocationRepresentation alloc] init];
        represent.showsAccuracyRing = YES;
        represent.showsHeadingIndicator = YES;
        represent.fillColor = [UIColor colorWithRed:58.0/255.0 green:227.0/255.0 blue:170.0/255.0 alpha:.3];
        represent.locationDotFillColor = [UIColor colorWithRed:58.0/255.0 green:227.0/255.0 blue:170.0/255.0 alpha:1];
        //    represent.strokeColor = [UIColor lightGrayColor];;
        //    represent.lineWidth = 2.f;
                UIImage * image = [UIImage mt_imageWithName:@"icon_current_location" inBundle:@"DGMapModule"];
                represent.image =  image;
        
        [_mapView updateUserLocationRepresentation:represent];
    }
    return _mapView;
}

- (UIImageView *)centerAnnotationView {
    if(!_centerAnnotationView){
        _centerAnnotationView = [[UIImageView alloc] initWithImage:[UIImage mt_imageWithName:@"icon_current_location" inBundle:@"DGMapModule"]];
        _centerAnnotationView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - CGRectGetHeight(self.centerAnnotationView.bounds) / 2);
        _centerAnnotationView.contentMode = UIViewContentModeScaleAspectFit;
     
    }
    return _centerAnnotationView;
}


 

@end
