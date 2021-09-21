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
@property (nonatomic)DGMapViewManager *mapViewManager ;
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
    [self.mapViewManager showMapWithFrame:vc.view.frame inSuperView:vc.view];
}

- (void)getCurrentAroundPOIWithKeyWord:(NSString *)keyword {

    
}


#pragma mark DGMapViewManagerDelegate

- (void)userChoosePlaceAddress:(NSDictionary *)address details:(nonnull NSDictionary *)details{
    [self.mapServiceDelegate updateUserChooseAddress:address details: details];
}
 



@end
