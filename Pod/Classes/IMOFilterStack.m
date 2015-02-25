//
//  IMOFilterStack.m
//  Pods
//
//  Created by Ivan Moskalev on 24.02.15.
//
//

#import "IMOFilterStack.h"

#import "IMFSStack.h"
#import "IMFSConverter.h"

@interface IMOFilterStack ()

@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) IMFSStack *pImpl;
@property (nonatomic, strong) IMFSConverter *converter;

@end


@implementation IMOFilterStack

@dynamic filters;

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
        _pImpl     = [[IMFSStack alloc] initWithFilters:filters];
        _converter = [IMFSConverter new];
        _queue     = [NSOperationQueue new];
    }
    return self;
}

- (NSArray *)filters
{
    return [self.pImpl filters];
}

- (void)processImage:(UIImage *)image completion:(void (^)(UIImage *, NSError *))completion
{
    [self.queue addOperationWithBlock:^{

        // Convert and forward to private implementation.
        CIImage *ret = [self.pImpl imageByApplyingFiltersToImage:[self.converter CIImageFromUIImage:image]];

        // Render in background...
        UIImage *result = [self.converter UIImageFromCIImage:ret referenceImage:image];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Bounce result to main thread.
            completion(result, nil);
        }];
    }];
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
