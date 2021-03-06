# IMOFilterStack

[![CI Status](http://img.shields.io/travis/ivanmoskalev/IMOFilterStack.svg?style=flat)](https://travis-ci.org/Ivan Moskalev/IMOFilterStack)
[![Version](https://img.shields.io/cocoapods/v/IMOFilterStack.svg?style=flat)](http://cocoadocs.org/docsets/IMOFilterStack)
[![License](https://img.shields.io/cocoapods/l/IMOFilterStack.svg?style=flat)](http://cocoadocs.org/docsets/IMOFilterStack)
[![Platform](https://img.shields.io/cocoapods/p/IMOFilterStack.svg?style=flat)](http://cocoadocs.org/docsets/IMOFilterStack)

Easily and asynchronously apply chains of [`CoreImage` filters][1]. Pure joy.

```objective-c
- (void)processImage
{
    UIImage *img = [UIImage imageNamed:@"TestImage.jpg"];
    [self.greyscaleAndPixelate processImage:img completion:^(UIImage *result, NSError *error) {
        [self.imageView setImage:result];
    }];
}

- (IMOFilterStack *)greyscaleAndPixelate 
{
    return [IMOFilterStack withFilters:@[ [CIFilter filterWithName:@"CIPhotoEffectNoir"], 
                                          [CIFilter filterWithName:@"CIPixellate"] 
                                          ]];
}
```

## Why use IMOFilterStack?

It is cool. Less code. Reusable. Declarative.

Normally you would have to repeat the following dance to process an `UIImage` using `CoreImage` filters:
- convert to `CIImage`
- setup an array of filters
- iterate through all these filters, applying them to image
- convert `CIImage` back to correct `UIImage` (either `CIImage`- or `CGImage`-backed)

`IMOFilterStack` implements all of these steps. Now all you need to do is to declaratively describe a filter chain. *A voila!* – simple as that. 

## Usage

Declare a filter chain like this:
```objective-c
- (IMOFilterStack *)imageBeautifier
{
    return [IMOFilterStack withFilters:@[ [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputEVKey, @(0.10f), nil],
                                          [CIFilter filterWithName:@"CIVibrance" keysAndValues:@"inputAmount", @(0.10f), nil] 
                                          ]];
}
```
```swift
lazy var beautifier: IMOFilterStack = {
    return IMOFilterStack(filters: [
        CIFilter(name: "CIExposureAdjust", withInputParameters: [kCIInputEVKey : NSNumber(double: 0.10)]),
        CIFilter(name: "CIVibrance", withInputParameters: ["inputAmount" : NSNumber(double: 0.10)])
        ])
}()
```

And then use it like this:
```objective-c
[self.imageBeautifier processImage:photo completion:^(UIImage *result, NSError *error) {
    [self.handler processedPhoto:result originalPhoto:photo];
}];
```
```swift
self.beautifier.processImage(photo) { (result, error) in
    self.handler?.processedPhoto(result, originalPhoto: photo)
}
```

`completion` block fires on the main thread. If you want to change that, provide your own instance of `NSOperationQueue` for callbacks. 

You can also provide (or tweak) the `NSOperationQueue` on which the processing takes place (for example, set [QoS][2]). 

`IMOFilterStack` is thread-safe (some thread-safety problems with multiple instances of `CIFilter` have been reported, I haven't reproduced them yet though). `IMOFilterStack` tries to do its best, running each processing operation on a deep copy of the original filter array.

Seems to be all for now, folks. Feel free to open issues, fork and send pull requests.

Happy processing!

## Installation

IMOFilterStack is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "IMOFilterStack"

## Author

Ivan Moskalev, moskalev-ivan@yandex.ru

## License

IMOFilterStack is available under the MIT license. See the LICENSE file for more info.

[1]: https://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CoreImageFilterReference/
[2]: https://developer.apple.com/library/ios/documentation/Cocoa/Reference/NSOperationQueue_class/index.html#//apple_ref/occ/instp/NSOperationQueue/maxConcurrentOperationCount
