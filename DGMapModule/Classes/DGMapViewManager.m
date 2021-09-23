//
//  DGMapViewManager.m
//  DGMapModule
//
//  Created by Tom on 2021/9/12.
//

#import "DGMapViewManager.h"
#import "UIImage+BundleImage.h"
#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
#import <MJExtension/MJExtension.h>
#define kCalloutViewMargin          -8


@interface DGMapViewManager ()<AMapSearchDelegate,MAMapViewDelegate>
//当前定位
@property(nonatomic,strong) CLLocation * currentStartLocation;
@property (nonatomic, strong) UIImageView          *centerAnnotationView;
@property (strong, nonatomic) MAPointAnnotation *startAnnotation;
@property (strong, nonatomic) MAPointAnnotation *destinationAnnotation;

@end

@implementation DGMapViewManager

- (UIImageView *)centerAnnotationView {
    if(!_centerAnnotationView){
        _centerAnnotationView = [[UIImageView alloc] initWithImage:[UIImage mt_imageWithName:@"icon_current_location" inBundle:@"DGMapModule"]];
        _centerAnnotationView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - CGRectGetHeight(self.centerAnnotationView.bounds) / 2);
        
//        [self.mapView addSubview:_centerAnnotationView];
    }
    return _centerAnnotationView;
}

- (instancetype)init{
    if(self == [super init]){
        _mapView = [[MAMapView alloc] initWithFrame:CGRectZero]; 
 
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        //设置地图缩放比例，即显示区域
        [_mapView setZoomLevel:19 animated:YES];
        _mapView.delegate = self;
        //设置定位精度
        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        //设置定位距离
        _mapView.distanceFilter = 5.0f;
//        //把中心点设成自己的坐标
//        _mapView.centerCoordinate = self.currentLocation.coordinate;
        
        MAUserLocationRepresentation *represent = [[MAUserLocationRepresentation alloc] init];
        represent.showsAccuracyRing = YES;
        represent.showsHeadingIndicator = YES;
        represent.fillColor = [UIColor colorWithRed:58.0/255.0 green:227.0/255.0 blue:170.0/255.0 alpha:.3];
        represent.locationDotFillColor = [UIColor colorWithRed:58.0/255.0 green:227.0/255.0 blue:170.0/255.0 alpha:1];
    //    represent.strokeColor = [UIColor lightGrayColor];;
    //    represent.lineWidth = 2.f;
//        UIImage * image = [UIImage mt_imageWithName:@"icon_current_location" inBundle:@"DGMapModule"];
//        represent.image =  image;
            
        [_mapView updateUserLocationRepresentation:represent];
        
    }
    return self;
}


- (void)showMapWithFrame:(CGRect)frame inSuperView:(UIView *)superView {
    
    [self.mapView setFrame:frame];
    [superView addSubview:self.mapView];
}


- (void)actionSearchAroundAt:(CLLocationCoordinate2D)coordinate
{
    [self searchReGeocodeWithCoordinate:coordinate];
    [self searchPoiWithCenterCoordinate:coordinate];
    
    
    [self centerAnnotationAnimimate];
}

/* 移动窗口弹一下的动画 */
- (void)centerAnnotationAnimimate {
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y -= 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];

    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y += 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];
}

-(void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate{
     
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
   
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiWithCenterCoordinate:(CLLocationCoordinate2D )coord
{
    AMapPOIAroundSearchRequest*request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:coord.latitude  longitude:coord.longitude];

    request.radius   = 1000;
//    request.types = self.currentType;
    request.sortrule = 0;
//    request.page     = self.searchPage;
    
    [self.search AMapPOIAroundSearch:request];
}

- (void)searchAroundWithKeyWords:(NSString*)keywords  andCoordinate:(CLLocationCoordinate2D)coordinate{
    AMapPOIAroundSearchRequest  *request=[[AMapPOIAroundSearchRequest alloc] init];
    request.radius = 10000;
    request.location=[AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.keywords = keywords;
    [self.search AMapPOIAroundSearch:request];
}


#pragma mark - MAMapViewDelegate
 

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.mapView.userTrackingMode == MAUserTrackingModeNone) {
     
        NSLog(@"%@",NSStringFromCGPoint(CGPointMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude)));
        self.currentStartLocation = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
        [self actionSearchAroundAt:self.mapView.centerCoordinate];
        [self.mapView removeAnnotation:self.startAnnotation];
        //创建大头针对象
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = self.mapView.centerCoordinate;
        self.startAnnotation = pointAnnotation;
        [self.mapView addAnnotation:self.startAnnotation];
    }
 }


#pragma mark 定位更新回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if(!updatingLocation)
        return ;
    
    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
    
    if(updatingLocation)
    {
        if (self.mapView.userTrackingMode == MAUserTrackingModeFollow) {
            NSLog(@"用户位置更新🔥%@",NSStringFromCGPoint(CGPointMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)));
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
            self.currentStartLocation = [userLocation.location copy];
    //        [self searchReGeocodeWithCoordinate:self.currentLocation.coordinate];
            self.mapView.userTrackingMode = MAUserTrackingModeNone;
        }
        
      
    }
    
    
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        
        return nil;
        
    }
    
    else if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        static NSString *reuseIndetifier = @"CustomAnnotationView";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage mt_imageWithName:@"icon_current_location" inBundle:@"DGMapModule"];
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    
    return nil;
}




- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
    if([view isKindOfClass:NSClassFromString(@"MAUserLocationView")]) {
      
       
        UIView * customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        UILabel *label  = [[UILabel alloc] initWithFrame:customView.frame];
        label.textColor = [UIColor whiteColor];
        label.text =  @"我的位置";
        label.font = [UIFont systemFontOfSize:12];
        [customView addSubview:label];
        customView.backgroundColor = [UIColor redColor];
        view.customCalloutView = [[MACustomCalloutView alloc] initWithCustomView:customView];
 
    }else  if([view isKindOfClass:NSClassFromString(@"CustomAnnotationView")]) {//自定义的大头针类
        CustomAnnotationView * customAnnotationView  = (CustomAnnotationView*)view;
        customAnnotationView.name = self.startAnnotation.title;

    }
     
}

#pragma mark -- AMapSearchDelegate
#pragma mark --地址编码回调
-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    AMapGeoPoint *point = response.geocodes[0].location;
    NSLog(@"----%lf====%lf",point.latitude,point.latitude);
}
 
#pragma mark --地址编码回调逆地理编码
 
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
 
    NSString *title =response.regeocode.addressComponent.city;
    NSString *address =response.regeocode.formattedAddress;
    NSLog(@"[--->]-----%@--%@",title,address);
    if([self.delegate respondsToSelector:@selector(userChoosePlaceAddress:details:)]){
        [self.delegate userChoosePlaceAddress:address details:[response.regeocode.addressComponent mj_keyValues]];
    }
    if (title.length == 0) {
        title = response.regeocode.addressComponent.province;
    }
    //    NSLog(@"=====%@",request.location);
    if (request.location.latitude == _currentStartLocation.coordinate.latitude&&request.location.longitude == _currentStartLocation.coordinate.longitude) {
 
        
        self.startAnnotation.title = title;

    }else{
 
    }
}

 

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    
}


 

- (AMapSearchAPI *)search {
    if(!_search){
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}


@end
