//
//  IMOFilterStack.m
//  Pods
//
//  Created by Ivan Moskalev on 24.02.15.
//
//

#import "IMOFilterStack.h"

@interface IMOFilterStack ()

@property (nonatomic, readonly, strong) NSOperationQueue *queue;

@end


@implementation IMOFilterStack

+ (instancetype)withFilters:(NSArray *)filters
{
    return [[self alloc] initWithFilters:filters];
}

- (instancetype)init
{
    return [self initWithFilters:nil];
}

- (instancetype)initWithFilters:(NSArray *)filters
{
    self = [super init];
    if (self) {
        _filters = [filters copy];
        _queue   = [NSOperationQueue new];
    }
    return self;
}

- (void)processImage:(UIImage *)image completion:(void (^)(UIImage *, NSError *))completion
{
    [self.queue addOperationWithBlock:^{
        CIImage *ciImage = [self CIImageFromUIImage:image];

        // Deep copy filters array...
        NSArray *filters = [[NSArray alloc] initWithArray:self.filters copyItems:YES];

        // Apply filters consecutively...
        for (CIFilter *filter in filters) {
            [filter setValue:ciImage forKey:kCIInputImageKey];
            ciImage = [filter outputImage];
        }

        // Render in background...
        UIImage *result = [self UIImageFromCIImage:ciImage referenceImage:image];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Bounce result to main thread.
            completion(result, nil);
        }];
    }];
}


#pragma mark - Misc

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


#pragma mark - Equality

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }

    if ([object isKindOfClass:self.class] == NO) {
        return NO;
    }

    return [self isEqualToStack:object];
}

- (BOOL)isEqualToStack:(IMOFilterStack *)other
{
    return [other.filters isEqualToArray:self.filters];
}

- (NSUInteger)hash
{
    return [self.filters hash] ^ [NSStringFromClass(self.class) hash];
}

@end
