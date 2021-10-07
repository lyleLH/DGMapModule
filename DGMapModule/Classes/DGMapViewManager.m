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
#import "RouterPlan.h"

#import "MANaviRoute.h"
#import "CommonUtility.h"



#import "DGMapSearch.h"



#define kCalloutViewMargin          -8

static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;



@interface DGMapViewManager ()<MAMapViewDelegate,DGMapSearchDelegate>

@property(nonatomic,strong)MAMapView *mapView;

//当前定位
@property(nonatomic,strong) CLLocation * currentStartLocation;

@property(nonatomic,copy)NSString *currentCity;
@property (nonatomic, strong) UIImageView          *centerAnnotationView;
@property (nonatomic, assign) NSInteger          currentChoosetype; //0 正在设置起点 1 正在设置终点
@property (strong, nonatomic) MAPointAnnotation *startAnnotation;
@property (strong, nonatomic) MAPointAnnotation *destinationAnnotation;
@property (nonatomic, strong) CustomAnnotationView * startAnnotationView ;
@property (nonatomic, strong) CustomAnnotationView * destinationAnnotationView ;
@property(nonatomic,strong) DGMapSearch * mapSearch;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;
@property (nonatomic, strong) AMapRoute *route;
/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;


@end

@implementation DGMapViewManager


- (instancetype)init {
    if(self ==[super init]){
        self.mapSearch = [[DGMapSearch alloc] initWithMapView:self.mapView];
        self.mapSearch.searchDelegate = self;
        _canDragToChoosePoint = YES;
    }
    return self;
}

#pragma mark -- DGMapModuleServiceInterface

- (void)planAnRoutePathWithPointStart:(NSDictionary*)start end:(NSDictionary*)end {
    /* 清空地图上已有的路线. */
    [self.naviRoute removeFromMapView];
    
    AMapPOI * startPOI = [AMapPOI mj_objectWithKeyValues:start];
    AMapPOI * endPOI = [AMapPOI mj_objectWithKeyValues:end];
    
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = CLLocationCoordinate2DMake(startPOI.location.latitude, startPOI.location.longitude);
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = CLLocationCoordinate2DMake(endPOI.location.latitude, endPOI.location.longitude);
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    self.destinationAnnotation = destinationAnnotation;
    
    [self.mapSearch routeSearchWithStart:CLLocationCoordinate2DMake(startPOI.location.latitude, startPOI.location.longitude) end:CLLocationCoordinate2DMake(endPOI.location.latitude, endPOI.location.longitude)];
    
    [self updateStartAnnotation:startPOI.name andLocation:startAnnotation.coordinate];
    [self updateEndAnnotation:endPOI.name andLocation:destinationAnnotation.coordinate];
}

- (void)updateChoosedStartLocation:(id)data {
    _currentChoosetype = 0;

    AMapPOI *model = [AMapPOI mj_objectWithKeyValues:data];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(model.location.latitude,model.location.longitude)];

    [self updateStartAnnotation:model.name andLocation:CLLocationCoordinate2DMake(model.location.latitude,model.location.longitude)];
}

- (void)updateChoosedEndLocation:(id)data {
    _currentChoosetype = 1;
    AMapPOI *model = [AMapPOI mj_objectWithKeyValues:data];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(model.location.latitude,model.location.longitude)];
    [self updateEndAnnotation:model.name andLocation:CLLocationCoordinate2DMake(model.location.latitude,model.location.longitude)];
}

- (void)showMapAndLoactionInView:(UIViewController * )vc {
    [self.mapView setFrame:vc.view.frame];
    [vc.view addSubview:self.mapView];
    [vc.view insertSubview:self.mapView  atIndex:0];
    _currentChoosetype = 0;
}

- (void)getCurrentAroundPOIWithCity:(nonnull NSString *)city andKeyWord:(nonnull NSString *)keyword {
    _currentChoosetype = 3;
    [self.mapSearch getCurrentAroundPOIWithCity:city andKeyWord:keyword];

}



#pragma mark -- DGMapModuleServiceInterface END

 

- (void)updateStartAnnotation:(NSString  *)title andLocation:(CLLocationCoordinate2D)location{
    [self.startAnnotationView removeFromSuperview];
    [self.mapView removeAnnotation:self.startAnnotation];
    //创建大头针对象
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.title = @"起点";
    pointAnnotation.coordinate = location;
    self.startAnnotation = pointAnnotation;
    [self centerAnnotationAnimimate];
    self.startAnnotation.title = title;
    [self.mapView addAnnotation:self.startAnnotation];
    [self.mapView setSelectedAnnotations:@[self.startAnnotation]];
    [self.centerAnnotationView removeFromSuperview];
  
 
}


- (void)updateEndAnnotation:(NSString  *)title andLocation:(CLLocationCoordinate2D)location{
    [self.destinationAnnotationView removeFromSuperview];
    [self.mapView removeAnnotation:self.destinationAnnotation];
    //创建大头针对象
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.title = @"终点";
    pointAnnotation.coordinate = location;
    self.destinationAnnotation = pointAnnotation;
    [self centerAnnotationAnimimate];
    self.destinationAnnotation.title = title;
    [self.mapView addAnnotation:self.destinationAnnotation];
    [self.mapView setSelectedAnnotations:@[self.destinationAnnotation]];
    [self.centerAnnotationView removeFromSuperview];
 
}

- (NSString *)getAddressName:(AMapPOISearchResponse *)response {
    NSString *address = @"";
    if(response.pois && response.pois.count>0){
        AMapPOI * poi = [response.pois firstObject];
        if(poi){
            address = poi.name;
        }
    }
    return address;
}


- (NSDictionary *)getAddressDetails:(AMapPOISearchResponse *)response {
    NSMutableDictionary * dic = NSMutableDictionary.new;
    if(response.pois && response.pois.count>0){
        AMapPOI * poi = [response.pois firstObject];
        if(poi){
            dic = [poi mj_keyValues];
        }
    }
    return dic;
}

#pragma mark -- 路径规划搜索结果
- (void)pathSearchResult:(AMapRouteSearchResponse *)response InRequest:(AMapRouteSearchBaseRequest *)request {
    self.route = response.route;
    self.currentCourse = 0;
    if (response.count > 0){
        [self presentCurrentCourse];
    }
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
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




#pragma mark -- POI搜索结果

- (void)coordinatePOISearchResult:(AMapPOISearchResponse *)response InRequest:(AMapPOISearchBaseRequest *)request  {
         if([request.class isEqual:[AMapPOIAroundSearchRequest class]]){
             AMapPOIAroundSearchRequest *  aroundSearch = (AMapPOIAroundSearchRequest*)request;
             if(aroundSearch.city &&aroundSearch.city>0){
                 if([self.delegate respondsToSelector:@selector(userSearchCityAndKeyWordResult:)]){
                     [self.delegate userSearchCityAndKeyWordResult:response.pois];
                 }
             }else{
                 NSDictionary * userCurrentLocationData = [self getAddressDetails:response];
                 _currentCity = userCurrentLocationData[@"city"];
                 [self.delegate updateUserLocation:userCurrentLocationData];
             }
         }
    
    if(_currentChoosetype!=3){
        if([self.delegate respondsToSelector:@selector(userChoosePlaceAddress:details:withType:)]){
            [self.delegate userChoosePlaceAddress:[self getAddressName:response] details:[self getAddressDetails:response] withType:_currentChoosetype];
        }
        if(_currentChoosetype == 0 ){
            [self updateStartAnnotation:[self getAddressName:response] andLocation:self.startAnnotation.coordinate];
        }else  if(_currentChoosetype == 1 ){
            [self updateEndAnnotation:[self getAddressName:response] andLocation:self.destinationAnnotation.coordinate];
        }
    }
    
        [self.centerAnnotationView removeFromSuperview];
}



#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated wasUserAction:(BOOL)wasUserAction {

    if(_canDragToChoosePoint ==YES){
        if(_currentChoosetype ==0){
            self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];
            [self.mapView addSubview:self.centerAnnotationView];
            [self.mapView removeAnnotation:self.startAnnotation];
        }else if(_currentChoosetype ==1){
            self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_end" inBundle:@"DGMapModule"];
            [self.mapView addSubview:self.centerAnnotationView];
            [self.mapView removeAnnotation:self.destinationAnnotation];
        }
    }
    
    
}

#pragma mark -- 地图显示区域改变后 得到选点 经纬度 发起搜索
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if(_canDragToChoosePoint ==YES){
        if (self.mapView.userTrackingMode == MAUserTrackingModeNone) {
            
            NSLog(@"%@",NSStringFromCGPoint(CGPointMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude)));
            self.currentStartLocation = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
            
            [self.mapSearch searchAroundWithKeyWords:@"" InCity:_currentCity andCoordinate:self.mapView.centerCoordinate];
            if(_currentChoosetype ==0){
                [self updateStartAnnotation:@"正在获取位置信息..." andLocation:self.mapView.centerCoordinate];
            }else if(_currentChoosetype ==1){
                [self updateEndAnnotation:@"正在获取位置信息..." andLocation:self.mapView.centerCoordinate];
            }
        }
    }
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
            NSLog(@"用户位置更新🔥%@",NSStringFromCGPoint(CGPointMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)));
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
            [self.mapSearch searchAroundWithKeyWords:@"" InCity:@"" andCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
            self.currentStartLocation = [userLocation.location copy];
            self.mapView.userTrackingMode = MAUserTrackingModeNone;
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
                if([self.delegate respondsToSelector:@selector(userChoosenAddressClicked:)]){
                    [self.delegate userChoosenAddressClicked:@""];
                }
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

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    
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
     
        
    }
    
}






- (UIImageView *)centerAnnotationView {
    if(!_centerAnnotationView){
        _centerAnnotationView = [[UIImageView alloc] initWithImage:[UIImage mt_imageWithName:@"icon_current_location" inBundle:@"DGMapModule"]];
        _centerAnnotationView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - CGRectGetHeight(self.centerAnnotationView.bounds) / 2);
     
    }
    return _centerAnnotationView;
}


- (MAMapView *)mapView {
    if(!_mapView){
        _mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
        
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        //设置地图缩放比例，即显示区域
        [_mapView setZoomLevel:17 animated:YES];
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
                UIImage * image = [UIImage mt_imageWithName:@"icon_current_location" inBundle:@"DGMapModule"];
                represent.image =  image;
        
        [_mapView updateUserLocationRepresentation:represent];
    }
    return _mapView;
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


@end
