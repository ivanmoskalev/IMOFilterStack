//
//  IMOFilterStackPrivate.h
//  Pods
//
//  Created by Ivan Moskalev on 25.02.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@interface IMOFilterStackPrivate : NSObject

@property (nonatomic, readonly, copy) NSArray *filters;

- (instancetype)initWithFilters:(NSArray *)ciFilters;
- (CIImage *)imageByApplyingFiltersToImage:(CIImage *)image;

@end
