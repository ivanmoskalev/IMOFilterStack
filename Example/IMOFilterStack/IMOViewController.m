//
//  IMOViewController.m
//  IMOFilterStack
//
//  Created by Ivan Moskalev on 02/24/2015.
//  Copyright (c) 2014 Ivan Moskalev. All rights reserved.
//

#import "IMOViewController.h"
#import "IMOFilterStack+IMOCustomFilterStacks.h"

@interface IMOViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end


@implementation IMOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    IMOFilterStack *stack = [IMOFilterStack redscaleRotateAndPixelateStack];

    [stack processImage:[UIImage imageNamed:@"TestImage.jpg"] completion:^(UIImage *result, NSError *error) {
        [self.imageView setImage:result];
    }];
}

@end
