//
//  DGMapView.m
//  DGMapModule
//
//  Created by Tom on 2021/10/10.
//

#import "DGMapView.h"
#import "UIImage+BundleImage.h"
 
#import "POIAnnotation.h"
#import "MAMapView+ZoomLevel.h"
#import "DGMapViewResultData.h"
#import "DDCustomAnnotationView.h"
#import <MJExtension/MJExtension.h>
#import "PointAnnotation.h"
@interface DGMapView () <MAMapViewDelegate>

@property (nonatomic, assign)  DGMapViewActionType mapViewActionType;
///地图对象
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,assign)NSInteger searchType; //0 用户定位点搜索 1 拖动点搜索
@property(nonatomic,assign)BOOL isUserLocationConfirmed;
@end


@interface DGMapView () <MAMapViewDelegate>


@property(nonatomic,strong)DGMapViewResultData * dataModel;


@end



@interface DGMapView ()
@property (nonatomic, strong)  MAAnnotationView * userLocationAnnotationView;
@property (nonatomic, strong) UIImageView *centerAnnotationView;
 
@property (strong, nonatomic) POIAnnotation *choosedPOIAnnotaion;
@property (strong, nonatomic) PointAnnotation *choosedPointAnnotation;

@property (assign, nonatomic) CLLocationCoordinate2D choosedCoordinate;

@property (strong, nonatomic) NSMutableArray <POIAnnotation *> *aroundPoiAnnotations;

@end


@implementation DGMapView

- (instancetype)init {
    if(self ==[super init]){
        [self addSubview:self.mapView];
        _isUserLocationConfirmed = NO;
    }
    return self;
}

#pragma mark -- DGMapServiceViewInterface

 
- (void)showReGeoSearchResult:(AMapReGeocodeSearchResponse *)response {
    self.dataModel.userCurrentLocationRegeoResponse = response;
    [self updateChoosedAnnotaionsViewWithResponse:response];
}
 


- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.showsAccuracyRing = NO;
        pre.image = [UIImage mt_imageWithName:@"addOil_currentLocation" inBundle:@"DGMapModule"];
        [self.mapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = NO;
        self.userLocationAnnotationView = view;
    }
}

#pragma mark 定位更新回调

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    // 让定位箭头随着方向旋转
    if (!updatingLocation && self.userLocationAnnotationView != nil) {
        [UIView animateWithDuration:0.1 animations:^{
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f);
        }];
        return ;
    }
    if (userLocation.location.horizontalAccuracy < 0) {
        return ;
    }
    if(updatingLocation) {
        if (self.mapView.userTrackingMode == MAUserTrackingModeFollow) {
            self.choosedCoordinate = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
            [self.mapView setCenterCoordinate:self.choosedCoordinate];
            self.mapView.userTrackingMode = MAUserTrackingModeNone;
            _mapView.scrollEnabled = YES;
            NSLog(@"🏃‍♀️🏃‍♀️🏃‍♀️定位点经纬度 --- ： %@",NSStringFromCGPoint(CGPointMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)));
//            self.searchType = 0;
#pragma mark -- 调用 逆地理搜索
            
            if([self.eventHandler respondsToSelector:@selector(confirmedUserLocationCoordinate:)]) {
                [self.eventHandler confirmedUserLocationCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
            }
            
//            [self searchReGeocodeWithCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
            _isUserLocationConfirmed = YES;
            
        }
    }
    
}

-(void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated wasUserAction:(BOOL)wasUserAction {
    if(wasUserAction) {
        [self.mapView removeAnnotation:  self.choosedPointAnnotation];
        [self.mapView removeAnnotation:self.choosedPOIAnnotaion];
        [self.mapView addSubview:self.centerAnnotationView];
        
        if(_mapViewActionType ==DGMapViewActionType_PickStartLocation){
            self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];
        }else if(_mapViewActionType ==DGMapViewActionType_PickEndLocation){
            self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_end" inBundle:@"DGMapModule"];
        }
    }
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated wasUserAction:(BOOL)wasUserAction {
    
    CLLocationCoordinate2D choosedCoordinate = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    self.choosedCoordinate = choosedCoordinate;
    if(wasUserAction){
        [self centerAnnotationAnimimate];
        [self.centerAnnotationView removeFromSuperview];
        if (self.mapView.userTrackingMode == MAUserTrackingModeNone) {
//            CLLocation * newLocation =  [[CLLocation alloc] initWithLatitude:choosedCoordinate.latitude longitude:choosedCoordinate.longitude];
            if(_isUserLocationConfirmed){
                
                NSLog(@"🍉🍉🍉拖选点经纬度 --- ： %@",NSStringFromCGPoint(CGPointMake(choosedCoordinate.latitude, choosedCoordinate.longitude)));
//                self.searchType = 1;
#pragma mark -- 调用 逆地理搜索
                if([self.eventHandler respondsToSelector:@selector(userDargToNewLocationCoordinate:)]) {
                    [self.eventHandler userDargToNewLocationCoordinate:choosedCoordinate];
                }
                
//                [self searchReGeocodeWithCoordinate:choosedCoordinate];
            }

        }
    }

}
 
- (NSString *) shortAddressWithResponse:(AMapReGeocodeSearchResponse *)response {
    NSString * string =@"";
    NSString * street = @"";
   
    street = [NSString stringWithFormat:@"%@%@", response.regeocode.addressComponent.streetNumber.street,
              response.regeocode.addressComponent.streetNumber.number];
    
    NSString * road = @"";
    if(street.length==0 && response.regeocode.roads.count>0) {
        AMapRoad * roadObj = response.regeocode.roads[0];
        road = roadObj.name;
    }
    
    NSString * aoiName = @"";
    
    if(response.regeocode.aois.count>0){
        AMapAOI * aoi =response.regeocode.aois[0];
        aoiName = aoi.name;
    }
    
    string = [NSString stringWithFormat:@"%@%@%@%@%@%@",
              response.regeocode.addressComponent.city,
              response.regeocode.addressComponent.district,
              response.regeocode.addressComponent.township,
              street,
              road,
              aoiName];
    return string;
}
 

- (void)updateChoosedAnnotaionsViewWithResponse:(AMapReGeocodeSearchResponse *)response{
    [self.mapView removeAnnotation:  self.choosedPointAnnotation];
    [self.mapView removeAnnotation:self.choosedPOIAnnotaion];
    
    [self.centerAnnotationView removeFromSuperview];
    
    NSString * addres =response.regeocode.formattedAddress;
//    NSString * addres = [self shortAddressWithResponse:response];
    PointAnnotation * point  = [[PointAnnotation  alloc] initWithAddress:addres andLocation:self.choosedCoordinate];
    self.choosedPointAnnotation = point;
    [self.mapView addAnnotation:point];
    
    
    //用户定位点数据含有的POI数组，将POI展示在地图上
    if(response.regeocode.pois.count>0){
        NSInteger maxCount =3;

        if(response.regeocode.pois.count< maxCount){
            maxCount = response.regeocode.pois.count;
        }

        if(response.regeocode.pois.count>=maxCount){
//            NSInteger minIndex = [self compareDistanceWithPois:[response.regeocode.pois subarrayWithRange:NSMakeRange(0, maxCount)]];

            [self.mapView removeAnnotations:self.aroundPoiAnnotations];
            [self.aroundPoiAnnotations removeAllObjects];

             [response.regeocode.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 if(idx>=maxCount) return;
//                 if(idx == minIndex){
//                     self.choosedCoordinate = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
//                     self.choosedPOIAnnotaion  = [[POIAnnotation alloc] initWithPOI:obj];
//                     [self.choosedPOIAnnotaion setTag:@"起点"];
//                     [self.mapView addAnnotation:self.choosedPOIAnnotaion];
//                     [self.centerAnnotationView removeFromSuperview];
//
//                     [self.mapView setCenterCoordinate:self.choosedCoordinate animated:YES];
//                 }else{
//                     POIAnnotation * annotation = [[POIAnnotation alloc] initWithPOI:obj];
//                     [self.aroundPoiAnnotations addObject:annotation];
//                 }
                 POIAnnotation * annotation = [[POIAnnotation alloc] initWithPOI:obj];
                 [self.aroundPoiAnnotations addObject:annotation];
                 
             }];
             [self.mapView addAnnotations:self.aroundPoiAnnotations];
        }

    }else{
//        if([response.regeocode.addressComponent.country isEqualToString:@"中国"] &&response.regeocode.addressComponent.city.length >0 ){
//
//            self.choosedAnnotaion  = [[POIAnnotation alloc] initWithTitle:response.regeocode.formattedAddress andAddress:response.regeocode.formattedAddress];
//            [self.choosedAnnotaion setTag:@"起点"];
//            [self.mapView addAnnotation:self.choosedAnnotaion];
//
//            PointAnnotation * point  = [[PointAnnotation  alloc] initWithAddress:response.regeocode.formattedAddress andLocation:self.choosedCoordinate ];
//            self.choosedPointAnnotation = point;
//            [self.mapView addAnnotation:point];
//
//
//            [self.centerAnnotationView removeFromSuperview];
//        }else{
//            [self.mapView setCenterCoordinate:self.choosedCoordinate animated:YES];
//        }

    }
}


//比较距离 人后将大头针设到最近的POI点

- (NSInteger)compareDistanceWithPois:(NSArray  <AMapPOI *> *)pois {
    MAMapPoint centerPoint =  MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude));
    NSMutableArray <NSNumber *>*distances = [NSMutableArray new];
    for (NSInteger i =0; i <pois.count; i ++) {
        AMapPOI * poi = pois[i];
        MAMapPoint point = MAMapPointForCoordinate(CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude));
        CLLocationDistance distance = MAMetersBetweenMapPoints(centerPoint,point);
        [distances addObject:[NSNumber numberWithDouble:distance]];
    }
    
    double xmax = -MAXFLOAT;
    double xmin = MAXFLOAT;
    for (NSNumber *num in distances) {
        double x = num.doubleValue;
        if (x < xmin) xmin = x;
        if (x > xmax) xmax = x;
    }
    NSNumber * minNumber = [NSNumber numberWithDouble:xmin];
    
    NSInteger minIndex = 0;
    for (NSInteger i =0 ; i <distances.count; i ++) {
        if([minNumber isEqualToNumber:distances[i]]){
            minIndex = i;
            break;
        }
    }
    return minIndex;
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
       
//        annotationView.calloutView.leftNumLabel.text = ddAnnotation.number;
        
//        annotationView.image = ddAnnotation.image;//设置大头针图片
//                if([[ddAnnotation tag] isEqualToString:@"起点"]){
//
//                    annotationView.image =  [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];
//                }else if([[ddAnnotation tag] isEqualToString:@"终点"]){
//                    annotationView.image =  [UIImage mt_imageWithName:@"icon_image_end" inBundle:@"DGMapModule"];
//                }else{
//                    annotationView.image = [UIImage mt_imageWithName:@"icon_poi_point" inBundle:@"DGMapModule"];
//                    annotationView.calloutView.hidden = YES;
//                }
//
        
//        annotationView.centerOffset = CGPointMake(0, -0.5*ddAnnotation.image.size.height);

        return annotationView;
    }
    
    return nil;
}



#pragma mark -- 逆地理搜索

-(void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate {
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    regeo.radius = 200;
    [self.search AMapReGoecodeSearch:regeo];
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


#pragma mark -- properties

- (UIImageView *)centerAnnotationView {
    if(!_centerAnnotationView){
        _centerAnnotationView = [[UIImageView alloc] initWithImage: [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"]];
        _centerAnnotationView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - CGRectGetHeight(self.centerAnnotationView.bounds) / 2);
        _centerAnnotationView.contentMode = UIViewContentModeScaleAspectFit;
     
    }
    return _centerAnnotationView;
}



- (MAMapView *)mapView {
    if(!_mapView){
        _mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
        _mapViewActionType = DGMapViewActionType_UserLocation;
        _mapView.scrollEnabled = NO;
        _mapView.mapType = MAMapTypeBus;
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
        
//        MAUserLocationRepresentation *represent = [[MAUserLocationRepresentation alloc] init];
//        represent.showsAccuracyRing = YES;
//        represent.showsHeadingIndicator = YES;
//        represent.fillColor = [UIColor colorWithRed:58.0/255.0 green:227.0/255.0 blue:170.0/255.0 alpha:.3];
//        represent.locationDotFillColor = [UIColor colorWithRed:58.0/255.0 green:227.0/255.0 blue:170.0/255.0 alpha:1];
//        //    represent.strokeColor = [UIColor lightGrayColor];;
//        //    represent.lineWidth = 2.f;
//                UIImage * image = [UIImage mt_imageWithName:@"icon_current_location" inBundle:@"DGMapModule"];
//                represent.image =  image;
//
//        [_mapView updateUserLocationRepresentation:represent];
        
//        //  自定义地图样式
//        NSString *path =   [[NSBundle bundleForClass:NSClassFromString(@"DGMapModule")] pathForResource:@"style" ofType:@"data"];
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        NSString *extrapath = [[NSBundle mainBundle] pathForResource:@"style_extra" ofType:@"data"];
//        NSData *extradata = [NSData dataWithContentsOfFile:extrapath];
//        MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
////        options.styleId = @"74dcfe3a9ed7a2b181e7af11aea1ea9d";
//        options.styleData = data;
//        options.styleExtraData = extradata;
//        [self.mapView setCustomMapStyleOptions:options];
//        [self.mapView setCustomMapStyleEnabled:YES];
        
    }
    return _mapView;
}



- (AMapSearchAPI *)search {
    if(!_search){
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

- (DGMapViewResultData *)dataModel {
    if(!_dataModel){
        _dataModel = [DGMapViewResultData new];
    }
    return _dataModel;
}

- (NSMutableArray<POIAnnotation *> *)aroundPoiAnnotations {
    if(!_aroundPoiAnnotations){
        _aroundPoiAnnotations = [NSMutableArray new];
    }
    return _aroundPoiAnnotations;
}


- (void)setSearchType:(NSInteger)searchType {
    _searchType = searchType;
    NSLog(@"🔍🔍🔍 searchType----- %ld",searchType);
}

@end
