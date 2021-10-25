//
//  UIImage+BundleImage.h
//  AFNetworking
//
//  Created by Tom on 2021/9/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BundleImage)

+ (UIImage *)mt_imageWithName:(NSString*)name inBundle:(NSString*)bundleName ;

@end

NS_ASSUME_NONNULL_END
