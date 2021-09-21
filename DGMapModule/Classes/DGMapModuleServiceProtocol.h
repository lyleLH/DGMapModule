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

- (void)getCurrentAroundPOIWithKeyWord:(NSString *)keyword;
@end


@protocol DGMapModuleServiceDelegate <NSObject>

- (void)updateUserChooseAddress:(NSDictionary*)address details:(NSDictionary *)details;

@end


NS_ASSUME_NONNULL_END
