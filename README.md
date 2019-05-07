# JCCloudProgressView

[![Version](https://img.shields.io/cocoapods/v/JCCloudProgressView.svg?style=flat)](https://cocoapods.org/pods/JCCloudProgressView)
[![License](https://img.shields.io/cocoapods/l/JCCloudProgressView.svg?style=flat)](https://cocoapods.org/pods/JCCloudProgressView)
[![Platform](https://img.shields.io/cocoapods/p/JCCloudProgressView.svg?style=flat)](https://cocoapods.org/pods/JCCloudProgressView)

## Example
![Icon](https://raw.githubusercontent.com/JasonHan1990/JCCloudProgressView/master/ExampleImages/JCCloudProgressView.png)
JCCloudProgressView is a progress indicator view with great graphics.

![Screen record](https://raw.githubusercontent.com/JasonHan1990/JCCloudProgressView/master/ExampleImages/JCCloudProgressView.gif)

## Requirements
`JCCloudProgressView` works on iOS 8+ and requires ARC to build. It depends on the following Apple frameworks:

Foundation.framework
UIKit.framework
CoreGraphics.framework

## Installation

`JCCloudProgressView` is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JCCloudProgressView'
```

Then Run `pod install`

## How to use

### Storyboard
You can create a `JCCloudProgressView` in storyboard by following steps:
* Drag a UIView to your storyboard
* Change the UIView class to `JCCloudProgressView`
![t-01](https://raw.githubusercontent.com/JasonHan1990/JCCloudProgressView/master/ExampleImages/Tutorial_01.png)
* Now you should be able to see a JCCloudProgressView in your storyboard.
![sample](https://raw.githubusercontent.com/JasonHan1990/JCCloudProgressView/master/ExampleImages/Example_Screen_Shot.png)
* Change the properties in right side panel.
![t-02](https://raw.githubusercontent.com/JasonHan1990/JCCloudProgressView/master/ExampleImages/Tutorial_02.png)

### Create with code
Of course, you can also create a JCCloudProgressView programmatically.


```ObjC
#import "JCCloudProgressView.h"

// Create a JCCloudProgressView
JCCloudProgressView *progressView = [[JCCloudProgressView alloc] init];
```
## Parameters

```ObjC
/**
 * Cloud layer fill color.
 * Default is [UIColor colorWithRed:0.9 green: 0.9 blue:0.9 alpha:1].
 */
@property (strong, nonatomic) IBInspectable UIColor *cloudColor;
/**
 * Gradient color A at location [0, 0]
 * Default is [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5].
 */
@property (strong, nonatomic) IBInspectable UIColor *colorA;
/**
 * Gradient color B at location [1, 1]
 * Default is [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5].
 */
@property (strong, nonatomic) IBInspectable UIColor *colorB;
/**
 * Progress level. From 0.0 to 1.0. Default is 0.0.
 */
@property (assign, nonatomic) IBInspectable double progress;
```
## Methods

```ObjC
/**
 * Start the wave layers animation.
 *
 * @note This method adds CABasicAnimation to both wave layers.
 */
- (void)startWaveRollingAnimation;

/**
 * Start the wave layers animation.
 *
 * @note This method removes CABasicAnimation to both wave layers.
 */
- (void)stopWaveRollingAnimation;

/**
 * Update the progress without animation.
 *
 * @param progress From 0.0 to 1.0.
 */
- (void)updateProgress:(double)progress;
/**
 * Update the progress.
 *
 * @param progress From 0.0 to 1.0.
 * @param animated Animated the progress update. YES or NO.
 */
- (void)updateProgress:(double)progress animated:(BOOL)animated;
```

## Author

JasonHan1990, namrie1990@gmail.com

## License

JCCloudProgressView is available under the MIT license. See the LICENSE file for more info.
