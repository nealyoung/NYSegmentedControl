# NYSegmentedControl

NYSegmentedControl is a customizable, animated replacement for UISegmentedControl inspired by controls found in Instagram, Foursquare, and other apps.

![Example](https://github.com/nealyoung/NYSegmentedControl/raw/master/example.gif)
![Screenshot 1](https://github.com/nealyoung/NYSegmentedControl/raw/master/screenshot-dark.png)
![Screenshot 2](https://github.com/nealyoung/NYSegmentedControl/raw/master/screenshot-light.png)

### Features
* Create segmented controls with animated selection indicator
* Customize colors, gradients, fonts, etc. either directly or globally with UIAppearance
* Configure distinct text styles for the selected segment

### Installation
#### Manual
Add the files to your project manually by dragging the NYSegmentedControl directory into your Xcode project.

#### CocoaPods
Add `pod 'NYSegmentedControl'` to your Podfile, and run `pod install`.

### Usage
Use is largely identical to UISegmentedControl. An example project is included in the NYSegmentedControlDemo directory.

```objc
// Import the class and create an NYSegmentedControl instance
#import "NYSegmentedControl.h"

// ...

NYSegmentedControl *segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Segment 1", @"Segment 2"]];

// Add desired targets/actions
[segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];

// Customize and size the control
segmentedControl.borderWidth = 1.0f;
segmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
segmentedControl.drawsGradientBackground = YES;
segmentedControl.segmentIndicatorInset = 2.0f;
segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.30 green:0.50 blue:0.88f alpha:1.0f];
segmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.20 green:0.35 blue:0.75f alpha:1.0f];
segmentedControl.segmentIndicatorAnimationDuration = 0.3f;
segmentedControl.segmentIndicatorBorderWidth = 0.0f;
[segmentedControl sizeToFit];

// Add the control to your view
self.navigationItem.titleView = self.segmentedControl;
```

### License
This project is released under the MIT License.
