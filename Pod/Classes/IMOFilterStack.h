//
//  IMOFilterStack.h
//  Pods
//
//  Created by Ivan Moskalev on 24.02.15.
//
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

/// IMOFilterStack handles asynchronous processing of images using a fixed set of CIFilters.
@interface IMOFilterStack : NSObject

/// The filters that are applied to all images passing through the stack.
@property (nonatomic, readonly, copy) NSArray *filters;

/// The queue on which image processing takes place. Default value is a generic background queue.
@property (nonatomic, strong) NSOperationQueue *workQueue;

/// The queue on which completion blocks are scheduled. Default value is [NSOperationQueue mainQueue].
@property (nonatomic, strong) NSOperationQueue *callbackQueue;


/// The designated initializer. Creates an instance of @c IMOFilterStack with given filters.
- (instancetype)initWithFilters:(NSArray *)filters;

/// A shorthand constructor. Creates an instance of @c IMOFilterStack with given filters.
+ (instancetype)withFilters:(NSArray *)filters;


/// Processes a single @p image and calls @p completion with @p result and, optionally, an @p error, if processing was unsuccessful.
- (void)processImage:(UIImage *)image completion:(void (^)(UIImage *result, NSError *error))completion;

@end
