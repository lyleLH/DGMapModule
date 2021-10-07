//
//  DGMapModuleServiceProtocol.h
//  DGMapModule
//
//  Created by Tom on 2021/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DGMapModuleServiceInterface<NSObject>
- (void)planAnRoutePathWithPointStart:(NSDictionary*)start end:(NSDictionary*)end;
- (void)showMapAndLoactionInView:(UIViewController * )vc;
//搜索新的定位点
- (void)getCurrentAroundPOIWithCity:(NSString *)city andKeyWord:(NSString *)keyword;

//- (void)updateChoosedLocation:(id)data;

- (void)updateChoosedStartLocation:(id)data;

- (void)updateChoosedEndLocation:(id)data;

@end


@protocol DGMapModuleServiceDelegate <NSObject>

- (void)updateUserLocation:(NSDictionary *)data;

- (void)userDidSelectedAddressCalloutView:(id)data;

- (void)getAddressSearchResult:(NSArray*)result;

- (void)userChoosePlaceAddress:(NSString *)address details:(NSDictionary *)details withType:(NSInteger)type;

- (void)userSearchCityAndKeyWordResult:(NSArray *)result ;

- (void)userChoosenAddressClicked:(id)data;

- (void)updateCurrentUserLocation:(id)data;


@end


NS_ASSUME_NONNULL_END
