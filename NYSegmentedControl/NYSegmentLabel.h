//
//  NYSegmentLabel.h
//  NYSegmentLabel
//
//  Copyright (c) 2015 Peter Gammelgaard. All rights reserved.
//
//  https://github.com/nealyoung/NYSegmentedControl
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NYSegmentLabel : UILabel

@property (nonatomic, strong) UIColor *alternativeTextColor;
@property (nonatomic, assign) CGRect maskFrame;
@property (nonatomic, assign) CGFloat maskCornerRadius;

@end