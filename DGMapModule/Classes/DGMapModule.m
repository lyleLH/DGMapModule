//
//  DGMapModule.m
//  DGMapModule
//
//  Created by Tom.Liu on 2021/9/10.
//

#import "DGMapModule.h"
#import "MapManager.h"
#import "UIImage+BundleImage.h"
#import "DGMapViewManager.h"





@interface DGMapModule ()  <DGMapViewManagerDelegate>
@property (nonatomic)MapManager *manager ;
@property (nonatomic)DGMapViewManager * mapViewManager ;
@property (nonatomic,weak)UIViewController * vc ;
@end

@implementation DGMapModule

- (instancetype)init {
    if(self = [super init]){
        self.mapViewManager = [[DGMapViewManager alloc] init];
        self.mapViewManager.delegate = self;
    }
    return  self;
}


- (void)showMapAndLoactionInView:(UIViewController * )vc {
    self.vc = vc;
    [self.mapViewManager showMapWithFrame:vc.view.frame inSuperView:vc.view];
}

- (void)getCurrentAroundPOIWithCity:(NSString *)city andKeyWord:(NSString *)keyword {
    CLLocationCoordinate2D userlocation =
    CLLocationCoordinate2DMake(self.mapViewManager.mapView.userLocation.location.coordinate.latitude, self.mapViewManager.mapView.userLocation.location.coordinate.longitude);
    [self.mapViewManager.mapSearch searchAroundWithKeyWords:keyword InCity:city andCoordinate:userlocation];
    
}


#pragma mark DGMapViewManagerDelegate

- (void)userChoosePlaceAddress:(NSDictionary *)address details:(nonnull NSDictionary *)details{
    [self.mapServiceDelegate updateUserChooseAddress:address details: details];
}
- (void)userSearchCityAndKeyWordResult:(NSArray *)result  {
    [self.mapServiceDelegate getAddressSearchResult:result];
}


- (void)userChoosenAddressClicked:(id)data {
    [self.mapServiceDelegate userDidSelectedAddressCalloutView:data];
}



@end
