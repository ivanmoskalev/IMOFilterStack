//
//  IMFSConverter.h
//  Pods
//
//  Created by Ivan Moskalev on 25.02.15.
//
//

#import <Foundation/Foundation.h>

@interface IMFSConverter : NSObject

- (CIImage *)CIImageFromUIImage:(UIImage *)image;
- (UIImage *)UIImageFromCIImage:(CIImage *)ciImage referenceImage:(UIImage *)refImage;

@end
