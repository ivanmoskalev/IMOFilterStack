//
//  IMOFilterStackPrivate.m
//  Pods
//
//  Created by Ivan Moskalev on 25.02.15.
//
//

#import "IMFSStack.h"

@implementation IMFSStack

- (instancetype)init
{
    return [self initWithFilters:nil];
}

- (instancetype)initWithFilters:(NSArray *)ciFilters
{
    self = [super init];
    if (self) {
        _filters = [ciFilters copy];
    }
    return self;
}

- (CIImage *)imageByApplyingFiltersToImage:(CIImage *)image
{
    CIImage *ret = image;

    // Deep copy filters array...
    NSArray *filters = [[NSArray alloc] initWithArray:self.filters copyItems:YES];

    // Apply filters consecutively...
    for (CIFilter *filter in filters) {
        [filter setValue:ret forKey:kCIInputImageKey];
        ret = [filter outputImage];
    }

    return ret;
}

@end
