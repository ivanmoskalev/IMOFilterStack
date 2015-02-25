//
//  IMOFilterStackTests.m
//  IMOFilterStackTests
//
//  Created by Ivan Moskalev on 02/24/2015.
//  Copyright (c) 2014 Ivan Moskalev. All rights reserved.
//

#import <Specta/Specta.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>


#import <IMOFilterStack/IMOFilterStack.h>
#import <IMOFilterStack/IMFSStack.h>
#import <IMOFilterStack/IMFSConverter.h>

@interface IMOFilterStack ()

@property (nonatomic, strong) IMFSStack *pImpl;
@property (nonatomic, strong) IMFSConverter *converter;

@end



SpecBegin(IMOFilterStackPrivate)

// Responsible for actual filter application
describe(@"IMFSStack", ^{

    IMFSStack *__block sut = nil;

    it(@"should init with array of filters", ^{
        NSArray *filterArray = @[ [CIFilter filterWithName:@"CIStraightenFilter"],
                                  [CIFilter filterWithName:@"CILanczosScaleTransform"] ];
        sut = [[IMFSStack alloc] initWithFilters:filterArray];

        expect(sut.filters).to.equal(filterArray);
    });

    context(@"processing image", ^{

        CIImage *initialImage      = [CIImage new]; // first input
        CIImage *firstFilterImage  = [CIImage new]; // after filter no. 1
        CIImage *secondFilterImage = [CIImage new]; // after filter no. 2

        beforeEach(^{
            sut = [[IMFSStack alloc] initWithFilters:@[ mock([CIFilter class]), mock([CIFilter class]) ]];

            [given([sut.filters[0] copyWithZone:NULL]) willReturn:sut.filters[0]];
            [given([sut.filters[1] copyWithZone:NULL]) willReturn:sut.filters[1]];

            [given([sut.filters[0] outputImage]) willReturn:firstFilterImage];
            [given([sut.filters[1] outputImage]) willReturn:secondFilterImage];
        });

        it(@"should pass through each filter exactly once", ^{
            CIImage *finalImage = [sut imageByApplyingFiltersToImage:initialImage];

            [MKTVerifyCount(sut.filters[0], times(1)) setValue:initialImage forKey:kCIInputImageKey];
            [MKTVerifyCount(sut.filters[0], times(1)) outputImage];
            [MKTVerifyCount(sut.filters[1], times(1)) setValue:firstFilterImage forKey:kCIInputImageKey];
            [MKTVerifyCount(sut.filters[1], times(1)) outputImage];

            expect(finalImage).to.equal(secondFilterImage);
        });

    });

});

SpecEnd


// TODO: Refactor conversion to additional component.

// Responsible for conversion and asynchronous processing.
SpecBegin(IMOFilterStack)

describe(@"IMOFilterStack", ^{

    IMOFilterStack *__block sut = nil;

    NSArray *filterArray = @[ [CIFilter filterWithName:@"CIStraightenFilter"],
                              [CIFilter filterWithName:@"CILanczosScaleTransform"] ];

    beforeEach(^{
        sut = [[IMOFilterStack alloc] initWithFilters:filterArray];
    });

    context(@"on init", ^{
        it(@"should create a private implementor with filters", ^{
            expect(sut.pImpl).toNot.beNil();
            expect(sut.pImpl.filters).to.equal(filterArray);
        });

        it(@"should create a converter", ^{
            expect(sut.converter).toNot.beNil();
            expect(sut.converter).to.beKindOf([IMFSConverter class]);
        });
    });

    context(@"on processImage call", ^{

        CIImage *ciImage     = [CIImage new];
        CIImage *filterImage = [CIImage new];
        UIImage *resultImage = [UIImage new];

        beforeEach(^{
            sut.pImpl     = mock([IMFSStack class]);
            sut.converter = mock([IMFSConverter class]);

            [given([sut.converter CIImageFromUIImage:HC_anything()]) willReturn:ciImage];
            [given([sut.pImpl imageByApplyingFiltersToImage:ciImage]) willReturn:filterImage];
            [given([sut.converter UIImageFromCIImage:filterImage referenceImage:HC_anything()]) willReturn:resultImage];
        });

        it(@"should use CIImage converted by converter", ^{
            waitUntil(^(DoneCallback done) {
                [sut processImage:[UIImage new] completion:^(UIImage *result, NSError *error) {
                    [MKTVerify(sut.pImpl) imageByApplyingFiltersToImage:ciImage];
                    done();
                }];
            });
        });

        it(@"should return UIImage converted by converter", ^{
            waitUntil(^(DoneCallback done) {
                [sut processImage:[UIImage new] completion:^(UIImage *result, NSError *error) {
                    expect(result).to.equal(resultImage);
                    done();
                }];
            });
        });

    });
    
});

SpecEnd
