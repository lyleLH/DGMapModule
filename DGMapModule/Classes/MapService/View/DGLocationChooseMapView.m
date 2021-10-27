//
//  DGLocationChooseMapView.m
//  DGMapModule
//
//  Created by Tom on 2021/10/25.
//

#import "DGLocationChooseMapView.h"
#import "UIImage+BundleImage.h"
 

#import "MAMapView+ZoomLevel.h"

#import "POIAnnotation.h"
#import "DDCustomAnnotationView.h"
#import <MJExtension/MJExtension.h>
#import "PointAnnotation.h"

#import "DGMapLocationModel.h"
@interface DGLocationChooseMapView ()<MAMapViewDelegate>


 
@property (nonatomic, strong) UIImageView *centerAnnotationView;
 
@property (strong, nonatomic) POIAnnotation *choosedPOIAnnotaion;
@property (strong, nonatomic) PointAnnotation *choosedPointAnnotation;

@property (strong, nonatomic) NSMutableArray <POIAnnotation *> *aroundPoiAnnotations;

@end

@interface DGLocationChooseMapView ()

@property (nonatomic, strong)  MAAnnotationView * userLocationAnnotationView;

///地图对象
@property(nonatomic,strong)MAMapView *mapView;


//@property(nonatomic,strong)AMapSearchAPI *search;




@end


@implementation DGLocationChooseMapView

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

- (void)setMapViewType:(DGMapViewActionType) type {
  
    _chooseType = type;
    
   
    if(type == DGMapViewActionType_PickEndLocation){
        [self.mapView removeAnnotations:self.mapView.annotations];
        self.mapView.showsUserLocation = NO;
        self.mapView.userTrackingMode = MAUserTrackingModeNone;
    }else{
        ///下面两行代码 进入地图就显示定位小蓝点
        self.mapView.showsUserLocation = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
    
}

#pragma mark -- DGMapServiceViewInterface
 
- (void)showAnAnnotationWithData:(DGMapLocationModel *)model {
    
    [self.mapView removeAnnotation:  self.choosedPointAnnotation];
    [self.mapView removeAnnotation:self.choosedPOIAnnotaion];
    
    [self.centerAnnotationView removeFromSuperview];
    
    NSString * addres = model.poi.name.length>0?model.poi.name:@"当前位置";
//    NSString * addres = [self shortAddressWithResponse:response];
    PointAnnotation * point  = [[PointAnnotation  alloc] initWithAddress:addres andLocation:model.location];
    self.choosedPointAnnotation = point;
    [self.mapView addAnnotation:point];
    
    
    //用户定位点数据含有的POI数组，将POI展示在地图上
    if(model.aroundPois.count>0){
        NSInteger maxCount =3;

        if(model.aroundPois.count< maxCount){
            maxCount = model.aroundPois.count;
        }

        if(model.aroundPois.count>=maxCount){
//            NSInteger minIndex = [self compareDistanceWithPois:[response.regeocode.pois subarrayWithRange:NSMakeRange(0, maxCount)]];

            [self.mapView removeAnnotations:self.aroundPoiAnnotations];
            [self.aroundPoiAnnotations removeAllObjects];

             [model.aroundPois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 if(idx>=maxCount) return;
 
                 POIAnnotation * annotation = [[POIAnnotation alloc] initWithPOI:obj];
                 [self.aroundPoiAnnotations addObject:annotation];
                 
             }];
             [self.mapView addAnnotations:self.aroundPoiAnnotations];
        }

    }else{


    }
}



- (void)showAnPoiPoint:(AMapPOI *)poi {
    [self.mapView removeAnnotation:self.choosedPointAnnotation];
    [self.mapView removeAnnotations:self.aroundPoiAnnotations];
    
    POIAnnotation * annotation = [[POIAnnotation alloc] initWithPOI:poi];
    [annotation setTag:@"起点"];
    [self.aroundPoiAnnotations addObject:annotation];
    [self.mapView addAnnotation:annotation];
}
  
- (void)showReGeoSearchResult:(DGMapLocationModel *)response {
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
            
            self.mapView.userTrackingMode = MAUserTrackingModeNone;
            NSLog(@"🏃‍♀️🏃‍♀️🏃‍♀️定位点经纬度 --- ： %@",NSStringFromCGPoint(CGPointMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)));
//#pragma mark -- 调用 逆地理搜索
            CLLocationCoordinate2D coor =  CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
            if([self.eventHandler respondsToSelector:@selector(confirmedUserLocationCoordinate:withType:)]) {
                [self.eventHandler confirmedUserLocationCoordinate:coor withType:DGMapViewActionType_UserLocation];
                
            }
    
        }
    }
}



-(void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated wasUserAction:(BOOL)wasUserAction {
    if(wasUserAction) {
        
        [self.mapView removeAnnotation:  self.choosedPointAnnotation];
        [self.mapView removeAnnotation:self.choosedPOIAnnotaion];
        [self.mapView addSubview:self.centerAnnotationView];
        
        if(_chooseType == DGMapViewActionType_PickStartLocation){
            self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];
        }else if(_chooseType == DGMapViewActionType_PickEndLocation){
            self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_end" inBundle:@"DGMapModule"];
        }
    }
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated wasUserAction:(BOOL)wasUserAction {
    
    CLLocationCoordinate2D choosedCoordinate = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    
    if(wasUserAction){
        [self centerAnnotationAnimimate];
        [self.centerAnnotationView removeFromSuperview];
        if (self.mapView.userTrackingMode == MAUserTrackingModeNone) {
//            CLLocation * newLocation =  [[CLLocation alloc] initWithLatitude:choosedCoordinate.latitude longitude:choosedCoordinate.longitude];
            if(_chooseType != DGMapViewActionType_UserLocation){
                
                NSLog(@"🍉🍉🍉拖选点经纬度 --- ： %@",NSStringFromCGPoint(CGPointMake(choosedCoordinate.latitude, choosedCoordinate.longitude)));

#pragma mark -- 调用 逆地理搜索
                if([self.eventHandler respondsToSelector:@selector(confirmedUserLocationCoordinate:withType:)]) {
                    [self.eventHandler confirmedUserLocationCoordinate:choosedCoordinate withType:_chooseType];
                    
                }
                 [self searchReGeocodeWithCoordinate:choosedCoordinate];
            }

        }
    }else{
      
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
 

- (void)updateChoosedAnnotaionsViewWithResponse:(DGMapLocationModel *)model{
    [self.mapView setCenterCoordinate:model.location];
    if(_chooseType ==  DGMapViewActionType_UserLocation){
//        [self.userLocationData fillWtihRegeoResponse:response];
        _chooseType =  DGMapViewActionType_PickStartLocation;
        [self showAnAnnotationWithData:model];
//        if([self.eventHandler respondsToSelector:@selector(mapViewConfirmedUserLocationData:)]){
//            [self.eventHandler mapViewConfirmedUserLocationData:self.userLocationData];
//        }
//
    }else{
        
        
        [self showAnAnnotationWithData:model];
//        if([self.eventHandler respondsToSelector:@selector(mapViewConfirmedAnChoosedLocationData:)]){
//            [self.eventHandler mapViewConfirmedAnChoosedLocationData:self.choosedLocationData];
//        }
    }
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
        }
        
        
        annotationView.image = image;
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
//    [self.search AMapReGoecodeSearch:regeo];
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

//        _mapView.scrollEnabled = NO;
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
        
    }
    return _mapView;
}



//- (AMapSearchAPI *)search {
//    if(!_search){
//        _search = [[AMapSearchAPI alloc] init];
//        _search.delegate = self;
//    }
//    return _search;
//}
//
- (NSMutableArray<POIAnnotation *> *)aroundPoiAnnotations {
    if(!_aroundPoiAnnotations){
        _aroundPoiAnnotations = [NSMutableArray new];
    }
    return _aroundPoiAnnotations;
}




@end
