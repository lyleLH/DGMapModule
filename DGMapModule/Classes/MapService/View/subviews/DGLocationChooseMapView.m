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

@property (strong, nonatomic) NSMutableArray <POIAnnotation *> *aroundPoiAnnotations;

@end

@interface DGLocationChooseMapView ()

@property (nonatomic, strong)  MAAnnotationView * userLocationAnnotationView;




//@property(nonatomic,strong)AMapSearchAPI *search;




@end


@implementation DGLocationChooseMapView

- (void)dealloc {
    NSLog(@"dealloc -- DGLocationChooseMapView -- 🍉");
}
 
- (void)setMapView:(MAMapView *)mapView {
    _mapView = mapView;
    _mapView.delegate = self;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];


}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.mapView];
    [self.mapView setFrame:self.bounds];
}

- (void)setMapViewType:(DGMapViewActionType) type {
  
    _chooseType = type;

    if(_chooseType == DGMapViewActionType_PickStartLocation){
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;

        self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];
    }else if(_chooseType == DGMapViewActionType_PickEndLocation){
        [self.mapView removeAnnotations:self.mapView.annotations];
        self.mapView.showsUserLocation = NO;
        self.mapView.userTrackingMode = MAUserTrackingModeNone;

        self.centerAnnotationView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - CGRectGetHeight(self.centerAnnotationView.bounds) / 2);
        self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_end" inBundle:@"DGMapModule"];

    }
    [self.mapView addSubview:self.centerAnnotationView];
}

#pragma mark -- DGMapServiceViewInterface
 
- (void)showAnAnnotationWithData:(DGMapLocationModel *)model {
    CLLocationCoordinate2D location =  CLLocationCoordinate2DMake(model.validLocation.latitude, model.validLocation.longitude);
    [self centerAnnotationAnimimate];

    [self.mapView setCenterCoordinate:location animated:YES];

    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.centerAnnotationView removeFromSuperview];

    
    NSString * addres = model.poi.name.length>0?model.poi.name:@"当前位置";
    PointAnnotation * point  = [[PointAnnotation  alloc] initWithAddress:addres andLocation:location];

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
    CLLocationCoordinate2D location =  CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);

    if([self.eventHandler respondsToSelector:@selector(confirmedUserLocationCoordinate:withType:)]) {
        [self.eventHandler confirmedUserLocationCoordinate:location withType:_chooseType];
    }

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
        [self.mapView addSubview:self.centerAnnotationView];
        self.centerAnnotationView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - CGRectGetHeight(self.centerAnnotationView.bounds) / 2);

       
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

#pragma mark -- 拖选点经纬度  调用 逆地理搜索
                if([self.eventHandler respondsToSelector:@selector(confirmedUserLocationCoordinate:withType:)]) {
                    [self.eventHandler confirmedUserLocationCoordinate:choosedCoordinate withType:_chooseType];
                    
                }
            }

        }
    }else{
      
    }

}

- (void)updateChoosedAnnotaionsViewWithResponse:(DGMapLocationModel *)model{
    [self.mapView setCenterCoordinate:model.location];
    if(_chooseType ==  DGMapViewActionType_UserLocation){
        _chooseType =  DGMapViewActionType_PickStartLocation;
        [self showAnAnnotationWithData:model];
    }else{
        
        
        [self showAnAnnotationWithData:model];

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
            [annotationView.imageView setFrame:CGRectMake(0, 0, 44, 44)];
        }
      
        
        annotationView.image = image;
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    id annotation = view.annotation;
    if([[annotation class] isEqual:[POIAnnotation class]]){
        POIAnnotation * poiAnnotation  = (POIAnnotation*)annotation;
        NSLog(@"🍉🍉🍉点击poi得到经纬度 --- ： %@",NSStringFromCGPoint(CGPointMake(poiAnnotation.poi.location.latitude, poiAnnotation.poi.location.longitude)));

        [self showAnPoiPoint:poiAnnotation.poi];
    }
    
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


- (NSMutableArray<POIAnnotation *> *)aroundPoiAnnotations {
    if(!_aroundPoiAnnotations){
        _aroundPoiAnnotations = [NSMutableArray new];
    }
    return _aroundPoiAnnotations;
}




@end
