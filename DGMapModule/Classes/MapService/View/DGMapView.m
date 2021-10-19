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
#import "DGMapViewResultData.h"
#import "DDCustomAnnotationView.h"
#import <MJExtension/MJExtension.h>

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

@property (nonatomic, strong) UIImageView *centerAnnotationView;
 
@property (strong, nonatomic) POIAnnotation *choosedAnnotaion;

@property (assign, nonatomic) CLLocationCoordinate2D choosedCoordinate;

@property (strong, nonatomic) NSMutableArray <POIAnnotation *> *poiAnnotations;

@end


@implementation DGMapView

- (instancetype)init {
    if(self ==[super init]){
        [self addSubview:self.mapView];
        _isUserLocationConfirmed = NO;
    }
    return self;
}





-(void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    [self.mapView addSubview:self.centerAnnotationView];
    
    if(_mapViewActionType ==DGMapViewActionType_PickStartLocation){
        self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_start" inBundle:@"DGMapModule"];
    }else if(_mapViewActionType ==DGMapViewActionType_PickEndLocation){
        self.centerAnnotationView.image =  [UIImage mt_imageWithName:@"icon_image_end" inBundle:@"DGMapModule"];
    }
    
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    CLLocationCoordinate2D choosedCoordinate = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    
    [self centerAnnotationAnimimate];
    if (self.mapView.userTrackingMode == MAUserTrackingModeNone) {
        CLLocation * newLocation =  [[CLLocation alloc] initWithLatitude:choosedCoordinate.latitude longitude:choosedCoordinate.longitude];
        if(_isUserLocationConfirmed){
            self.choosedCoordinate = choosedCoordinate;
            NSLog(@"🍉🍉🍉拖选点经纬度 --- ： %@",NSStringFromCGPoint(CGPointMake(choosedCoordinate.latitude, choosedCoordinate.longitude)));
            self.searchType = 1;
            [self searchReGeocodeWithCoordinate:choosedCoordinate];
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
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
            self.mapView.userTrackingMode = MAUserTrackingModeNone;
            _mapView.scrollEnabled = YES;
            NSLog(@"🏃‍♀️🏃‍♀️🏃‍♀️定位点经纬度 --- ： %@",NSStringFromCGPoint(CGPointMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)));
            self.searchType = 0;
            [self searchReGeocodeWithCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
            _isUserLocationConfirmed = YES;
//            [self.eventHandler mapviewGetUserCurrentLoaction:[userLocation.location copy]];
        }
    }
    
}

#pragma mark -- 搜索回调
#pragma mark -- 地址编码回调逆地理编码

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"💥💥💥💥 %@",error);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if(self.searchType ==0){
        self.dataModel.userCurrentLocationRegeoResponse = response;
    }else if(self.searchType ==1){
        self.dataModel.choosedLocationRegeoResponse = response;
    }
    
    
//    NSLog(@"%@",[response mj_keyValues]);
}



#pragma mark -- private

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




- (void)setSearchType:(NSInteger)searchType {
    _searchType = searchType;
    NSLog(@"🔍🔍🔍 searchType----- %ld",searchType);
}

@end
