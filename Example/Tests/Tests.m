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
#import <IMOFilterStack/IMOFilterStackPrivate.h>

@interface IMOFilterStack ()

@property (nonatomic, strong) IMOFilterStackPrivate *pImpl;

@end



SpecBegin(IMOFilterStackPrivate)

// Responsible for actual filter application
describe(@"IMOFilterStackPrivate", ^{

    IMOFilterStackPrivate *__block sut = nil;

    it(@"should init with array of filters", ^{
        NSArray *filterArray = @[ [CIFilter filterWithName:@"CIStraightenFilter"],
                                  [CIFilter filterWithName:@"CILanczosScaleTransform"] ];
        sut = [[IMOFilterStackPrivate alloc] initWithFilters:filterArray];

        expect(sut.filters).to.equal(filterArray);
    });

    context(@"processing image", ^{

        CIImage *initialImage      = [CIImage new]; // first input
        CIImage *firstFilterImage  = [CIImage new]; // after filter no. 1
        CIImage *secondFilterImage = [CIImage new]; // after filter no. 2

        beforeEach(^{
            sut = [[IMOFilterStackPrivate alloc] initWithFilters:@[ mock([CIFilter class]), mock([CIFilter class]) ]];

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
    });

    context(@"on processImage call", ^{

        UIImage *__block image = nil;

        beforeEach(^{
            image     = mock([UIImage class]);
            sut.pImpl = mock([IMOFilterStackPrivate class]);
        });

        it(@"if image is backed by CIImage should forward CIImage to implementor", ^{
            waitUntil(^(DoneCallback done) {
                CIImage *ciImage = [CIImage new];
                [given([image CIImage]) willReturn:ciImage];

                [sut processImage:image completion:^(UIImage *result, NSError *error) {
                    [MKTVerify(sut.pImpl) imageByApplyingFiltersToImage:ciImage];
                    done();
                }];
            });
        });

        it(@"if image is backed by CGImage should convert it and forward CIImage to implementor", ^{
            waitUntil(^(DoneCallback done) {
                image = [UIImage imageNamed:@"TestImage.jpg"]; // real this time

                [sut processImage:image completion:^(UIImage *result, NSError *error) {
                    [MKTVerify(sut.pImpl) imageByApplyingFiltersToImage:HC_instanceOf([CIImage class])];
                    done();
                }];
            });
        });

    });
    
});

SpecEnd
