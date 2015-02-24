//
//  IMOFilterStack+IMOCustomFilterStacks.m
//  IMOFilterStack
//
//  Created by Ivan Moskalev on 24.02.15.
//  Copyright (c) 2015 Ivan Moskalev. All rights reserved.
//

#import "IMOFilterStack+IMOCustomFilterStacks.h"

@implementation IMOFilterStack (IMOCustomFilterStacks)

+ (IMOFilterStack *)redscaleRotateAndPixelateStack
{
    return [IMOFilterStack withFilters:@[
                                         [CIFilter filterWithName:@"CIColorMonochrome" withInputParameters:@{ kCIInputColorKey : [CIColor colorWithRed:1. green:0. blue:0.] }],
                                         [CIFilter filterWithName:@"CIStraightenFilter" withInputParameters:@{ kCIInputAngleKey : @(3 * M_PI / 180.0) }],
                                         [CIFilter filterWithName:@"CIPixellate"]
                                         ]];
}

@end
