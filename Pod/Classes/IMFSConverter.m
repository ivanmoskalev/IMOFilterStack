//
//  IMFSConverter.m
//  Pods
//
//  Created by Ivan Moskalev on 25.02.15.
//
//

#import "IMFSConverter.h"

@implementation IMFSConverter

- (CIImage *)CIImageFromUIImage:(UIImage *)image
{
    CIImage *ciImage = [image CIImage];
    if (ciImage != nil) {
        return ciImage;
    }

    CGImageRef cgImage = [image CGImage];
    if (cgImage != NULL) {
        return [CIImage imageWithCGImage:cgImage];
    }

    return nil;
}

- (UIImage *)UIImageFromCIImage:(CIImage *)ciImage referenceImage:(UIImage *)refImage
{
    if ([refImage CGImage]) {
        // Restore as CGImage-backed UIImage.
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:ciImage fromRect:[ciImage extent]];
        return [UIImage imageWithCGImage:cgImage scale:[refImage scale] orientation:[refImage imageOrientation]];
    }

    // Restore as CIImage-backed UIImage.
    return [UIImage imageWithCIImage:ciImage scale:[refImage scale] orientation:[refImage imageOrientation]];
}

@end
