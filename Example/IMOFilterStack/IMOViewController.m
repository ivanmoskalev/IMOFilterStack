//
//  IMOViewController.m
//  IMOFilterStack
//
//  Created by Ivan Moskalev on 02/24/2015.
//  Copyright (c) 2014 Ivan Moskalev. All rights reserved.
//

#import "IMOViewController.h"
#import <IMOFilterStack/IMOFilterStack.h>

@interface IMOViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end


@implementation IMOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    IMOFilterStack *stack = [self redscaleRotateAndPixelateStack];

    [stack processImage:[UIImage imageNamed:@"TestImage.jpg"] completion:^(UIImage *result, NSError *error) {
        [self.imageView setImage:result];
    }];
}

- (IMOFilterStack *)redscaleRotateAndPixelateStack
{
    return [IMOFilterStack withFilters:@[
                                         [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputColorKey, [CIColor colorWithRed:1. green:0. blue:0.], nil],
                                         [CIFilter filterWithName:@"CIStraightenFilter" keysAndValues:kCIInputAngleKey, @(3 * M_PI / 180.0)],
                                         [CIFilter filterWithName:@"CIPixellate"]
                                         ]];
}

@end
