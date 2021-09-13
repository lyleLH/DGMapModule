//
//  DGMapViewManager.m
//  DGMapModule
//
//  Created by Tom on 2021/9/12.
//

#import "DGMapViewManager.h"
#import "UIImage+BundleImage.h"
#import "CustomAnnotationView.h"

#import <MJExtension/MJExtension.h>
#define kCalloutViewMargin          -8


@interface DGMapViewManager ()<AMapSearchDelegate,MAMapViewDelegate>
//当前定位
@property(nonatomic,strong) CLLocation *currentLocation;

@end

@implementation DGMapViewManager

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
    //    represent.strokeColor = [UIColor lightGrayColor];;
    //    represent.lineWidth = 2.f;
        UIImage * image = [UIImage mt_imageWithName:@"icon_current_location" inBundle:@"DGMapModule"];
        represent.image =  image;
        
        [_mapView updateUserLocationRepresentation:represent];
        
    }
    return self;
}


- (void)showMapWithFrame:(CGRect)frame inSuperView:(UIView *)superView {
    
    [self.mapView setFrame:frame];
    [superView addSubview:self.mapView];
}




-(void)reGeoCodingWithCoordinate:(CLLocationCoordinate2D)coordinate{
     
    AMapReGeocodeSearchRequest *request =[[AMapReGeocodeSearchRequest alloc] init];
    request.location =[AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.search AMapReGoecodeSearch:request];
   
}

- (void)searchAroundWithKeyWords:(NSString*)keywords  andCoordinate:(CLLocationCoordinate2D)coordinate{
    AMapPOIAroundSearchRequest  *request=[[AMapPOIAroundSearchRequest alloc] init];
    request.radius = 10000;
    request.location=[AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.keywords = keywords;
    [self.search AMapPOIAroundSearch:request];
}


#pragma mark - MAMapViewDelegate


#pragma mark 定位更新回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        self.currentLocation = [userLocation.location copy];
        [self reGeoCodingWithCoordinate:self.currentLocation.coordinate];
    }
    
    
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        
        return nil;
        
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
    if([view isKindOfClass:NSClassFromString(@"MAUserLocationView")]) {
      
       
        UIView * customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        UILabel *label  = [[UILabel alloc] initWithFrame:customView.frame];
        label.textColor = [UIColor whiteColor];
        label.text =  mapView.userLocation.title;
        label.font = [UIFont systemFontOfSize:12];
        [customView addSubview:label];
        customView.backgroundColor = [UIColor redColor];
        view.customCalloutView = [[MACustomCalloutView alloc] initWithCustomView:customView];
 
    }
     
}

#pragma mark -- AMapSearchDelegate
#pragma mark --地址编码回调
-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    AMapGeoPoint *point = response.geocodes[0].location;
    NSLog(@"----%lf====%lf",point.latitude,point.latitude);
}
 
#pragma mark --地址编码回调逆地理编码查询回调函数
 
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    //我们把编码后的地理位置，显示到 大头针的标题和子标题上
    NSString *title =response.regeocode.addressComponent.city;
    NSLog(@"[--->]-----%@",title);
    if (title.length == 0) {
        title = response.regeocode.addressComponent.province;
    }
    //    NSLog(@"=====%@",request.location);
    if (request.location.latitude == _currentLocation.coordinate.latitude&&request.location.longitude == _currentLocation.coordinate.longitude) {
        _mapView.userLocation.title = title;
        _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
        
//        _anomationPoint = [[MAPointAnnotation alloc]init];
//        _anomationPoint.coordinate  = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
//        [self.mapView addAnnotation:_anomationPoint];
        [self.mapView selectAnnotation:self.mapView.userLocation animated:YES];

    }else{
//        self.anomationPoint.title = title;
//        self.anomationPoint.subtitle = response.regeocode.formattedAddress;
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
