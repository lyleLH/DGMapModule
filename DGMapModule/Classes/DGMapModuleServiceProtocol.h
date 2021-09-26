//
//  DGMapModuleServiceProtocol.h
//  DGMapModule
//
//  Created by Tom on 2021/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DGMapModuleServiceInterface<NSObject>

- (void)showMapAndLoactionInView:(UIViewController * )vc;

- (void)getCurrentAroundPOIWithCity:(NSString *)city andKeyWord:(NSString *)keyword;
@end


@protocol DGMapModuleServiceDelegate <NSObject>

- (void)updateUserChooseAddress:(NSDictionary*)address details:(NSDictionary *)details;
- (void)userDidSelectedAddressCalloutView:(id)data;

- (void)getAddressSearchResult:(NSArray*)result;
@end


NS_ASSUME_NONNULL_END
