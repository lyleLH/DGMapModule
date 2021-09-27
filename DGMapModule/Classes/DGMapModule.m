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
@end

@implementation DGMapModule

- (instancetype)init {
    if(self = [super init]){
        self.mapViewManager = [[DGMapViewManager alloc] init];
        self.mapViewManager.delegate = self;
    }
    return  self;
}


#pragma mark -- DGMapModuleServiceInterface

- (void)updateChoosedLocation:(id)data {
    [self.mapViewManager updateChoosedLocation:data];
}




- (void)showMapAndLoactionInView:(UIViewController * )vc {
    [self.mapViewManager showMapAndLoactionInView:vc];
}

- (void)getCurrentAroundPOIWithCity:(NSString *)city andKeyWord:(NSString *)keyword {
    [self.mapViewManager.mapSearch getCurrentAroundPOIWithCity:city andKeyWord:keyword];
    
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
