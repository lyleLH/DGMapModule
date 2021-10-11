//
//  DGMapView.m
//  DGMapModule
//
//  Created by Tom on 2021/10/10.
//

#import "DGMapView.h"
#import "UIImage+BundleImage.h"
#import "CustomAnnotationView.h"



@interface DGMapView () <MAMapViewDelegate>

@property (nonatomic, assign)  DGMapViewActionType mapViewActionType;;

///地图对象
@property(nonatomic,strong)MAMapView *mapView;

@end

@interface DGMapView ()

@property (nonatomic, strong) UIImageView          *centerAnnotationView;

@property (strong, nonatomic) MAPointAnnotation *startAnnotation;
@property (strong, nonatomic) MAPointAnnotation *destinationAnnotation;
@property (nonatomic, strong) CustomAnnotationView * startAnnotationView ;
@property (nonatomic, strong) CustomAnnotationView * destinationAnnotationView ;


@end

@implementation DGMapView




- (UIImageView *)centerAnnotationView {
    if(!_centerAnnotationView){
        _centerAnnotationView = [[UIImageView alloc] initWithImage:[UIImage mt_imageWithName:@"icon_current_location" inBundle:@"DGMapModule"]];
        _centerAnnotationView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - CGRectGetHeight(self.centerAnnotationView.bounds) / 2);
        _centerAnnotationView.contentMode = UIViewContentModeScaleAspectFit;
     
    }
    return _centerAnnotationView;
}


#pragma mark -- DGMapServiceViewInterface

- (void)addAnAnnotaionViewWithPOIData:(AMapPOI *)poi {
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    annotation.title = poi.formattedDescription;
    if(_mapViewActionType == DGMapViewActionType_PickStartLocation){
       
        [self setStartAnnotation:annotation];
    }else if(_mapViewActionType == DGMapViewActionType_PickStartLocation) {
        
    }
    
}

- (void)setStartAnnotation:(MAPointAnnotation *)startAnnotation {
  
    if(_startAnnotation &&[self.mapView.annotations containsObject:_startAnnotation]){
        [self.mapView removeAnnotation:_startAnnotation];
        _startAnnotation = nil;
    }
    _startAnnotation = startAnnotation;
//    CustomAnnotationView *annotationView = [[CustomAnnotationView alloc] initWithAnnotation:startAnnotation reuseIdentifier:@"startAnnotation"];
//    annotationView.buttonAction = ^{
//
//    };
//    self.startAnnotationView = annotationView ;
    
    
  
    [self.mapView addAnnotation:_startAnnotation];
    [self.mapView setSelectedAnnotations:@[_startAnnotation]];
    [self.centerAnnotationView removeFromSuperview];
    NSLog(@"起点annotation%@",self.mapView.annotations );
}


- (void)setDestinationAnnotation:(MAPointAnnotation *)destinationAnnotation {
    if(_destinationAnnotation &&[self.mapView.annotations containsObject:_destinationAnnotation]){
        [self.mapView removeAnnotation:_destinationAnnotation];
        _destinationAnnotation = nil;
    }
    _destinationAnnotation = destinationAnnotation;
//    CustomAnnotationView *annotationView = [[CustomAnnotationView alloc] initWithAnnotation:startAnnotation reuseIdentifier:@"startAnnotation"];
//    annotationView.buttonAction = ^{
//
//    };
//    self.startAnnotationView = annotationView ;
    
    
  
    [self.mapView addAnnotation:_destinationAnnotation];
    [self.mapView setSelectedAnnotations:@[_destinationAnnotation]];
    [self.centerAnnotationView removeFromSuperview];
    NSLog(@"起点annotation%@",self.mapView.annotations );
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
        [self.mapView removeAnnotation:self.startAnnotation];
        self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];
        [self.mapView addSubview:self.centerAnnotationView];
    }else if(_mapViewActionType ==DGMapViewActionType_PickEndLocation){
        [self.mapView removeAnnotation:self.destinationAnnotation];
        self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_end" inBundle:@"DGMapModule"];
        [self.mapView addSubview:self.centerAnnotationView];
    }
    
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if(_mapViewActionType !=DGMapViewActionType_UserLocation){
        if (self.mapView.userTrackingMode == MAUserTrackingModeNone) {
            CLLocation * newLocation =  [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
            [self.eventHandler mapviewScrollToANewLoaction:newLocation withType:_mapViewActionType];
        }
    }
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"CustomAnnotationView";
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
        
        if([annotation isEqual:self.startAnnotation]) {
            annotationView.image =  [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];
            self.startAnnotationView = annotationView;
            [self.startAnnotationView updateContent:self.startAnnotation.title];
        }else{
            annotationView.image =  [UIImage mt_imageWithName:@"icon_image_end" inBundle:@"DGMapModule"];
            self.destinationAnnotationView = annotationView;
            [self.destinationAnnotationView updateContent:self.destinationAnnotation.title];
        }

        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
//        static NSString *reuseIndetifier = @"CustomAnnotationView";
//        CustomAnnotationView *annotationView = (CustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        
        return annotationView;
    }
    
    
    return nil;
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


@end
